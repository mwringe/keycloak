<%@ page import="org.keycloak.example.oauth.ProductDatabaseClient" %>
<%@ page import="org.keycloak.representations.AccessTokenResponse" %>
<%@ page import="org.keycloak.representations.IDToken" %>
<%@ page import="org.keycloak.servlet.ServletOAuthClient" %>
<%@ page import="org.keycloak.representations.UserClaimSet" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
 pageEncoding="ISO-8859-1"%>
<%@ page session="false" %>
<html>
<head>
    <title>Pull Page</title>
</head>
<body>
<%
    java.util.List<String> list = null;
    try {
        AccessTokenResponse tokenResponse = ProductDatabaseClient.getTokenResponse(request);
        if (tokenResponse.getIdToken() != null) {
            IDToken idToken = ServletOAuthClient.extractIdToken(tokenResponse.getIdToken());
            UserClaimSet claimSet = idToken.getUserClaimSet();
            out.println("<p><i>Change client claims in admin console to view personal info of user</i></p>");
            if (claimSet.getPreferredUsername() != null) {
                out.println("<p>Username: " + claimSet.getPreferredUsername() + "</p>");
            }
            if (claimSet.getName() != null) {
                out.println("<p>Full Name: " + claimSet.getName() + "</p>");
            }
            if (claimSet.getEmail() != null) {
                out.println("<p>Email: " + claimSet.getEmail() + "</p>");
            }
        }
        list = ProductDatabaseClient.getProducts(request, tokenResponse.getToken());
    } catch (ProductDatabaseClient.Failure failure) {
        out.println("There was a failure processing request.  You either didn't configure Keycloak properly, or maybe" +
                "you just forgot to secure the database service?");
        out.println("Status from database service invocation was: " + failure.getStatus());
        return;
    }
%>
<h2>Pulled Product Listing</h2>
<%
    for (String prod : list)
{
   out.print("<p>");
   out.print(prod);
   out.println("</p>");

}
%>
<br><br>
</body>
</html>