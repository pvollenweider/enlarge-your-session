<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="javascript" resources="jquery.min.js"/>

<c:choose>
    <c:when test="${renderContext.editMode}">
        <div class="alert alert-warning" role="alert">
            In preview or live mode, this component will refresh the current user session using an ajax call on a non
            cached resource 5 seconds before the session timeout (${fn:substringBefore(pageContext.session.maxInactiveInterval/60,'.')}
            minutes).
        </div>
    </c:when>
    <c:otherwise>
        <c:set var="timeout" value="${(pageContext.session.maxInactiveInterval * 1000) - 5000 }"/>
        <c:url var="timestampUrl" value="${url.base}${currentNode.path}.refresh.html.ajax" context="/"/>
        <script>
            function executeQuery() {
                $.ajax({
                    url: '${timestampUrl}',
                    success: function (data) {
                        console.log( "Your session has been extended to prevent timeout!" );
                    }
                });
                setTimeout(executeQuery, ${timeout});
            }
            $(document).ready(function () {
                setTimeout(executeQuery, ${timeout});
            });
        </script>
    </c:otherwise>
</c:choose>
