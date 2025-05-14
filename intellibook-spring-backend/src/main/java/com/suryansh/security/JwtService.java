package com.suryansh.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtService {

    @Value("${secret_key}")
    private String SECRET_KEY;

    @Value("${expiration_time}")
    private long EXPRESSION_TIME;

    public String generateToken(String userId,
                                Map<String, Object> claims) {
        ZonedDateTime nowInIndia = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        ZonedDateTime expirationTime = nowInIndia.plusMinutes(EXPRESSION_TIME);

        return Jwts
                .builder()
                .claims(claims)
                .subject(userId)
                .issuedAt(Date.from(nowInIndia.toInstant()))
                .expiration(Date.from(expirationTime.toInstant()))
                .signWith(getSignInKey(),Jwts.SIG.HS256)
                .compact();
    }
    public Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSignInKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
    private  <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private SecretKey getSignInKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String extractUserId(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    private Boolean isTokenExpired(String token) {
        return extractClaim(token,Claims::getExpiration)
                .before(new Date());
    }

    public Boolean validateToken(String token, String id) {
        final String userId = extractUserId(token);
        return userId.equals(id) && !isTokenExpired(token);
    }

    public Instant getTokenExpirationTime(String token) {
        Claims claims = extractAllClaims(token);
        Date expiration = claims.getExpiration();
        return expiration.toInstant();
    }
}
