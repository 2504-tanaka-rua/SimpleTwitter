<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="./css/style.css" rel="stylesheet" type="text/css">
        <title>簡易Twitter</title>
    </head>
    <body>
		<div class="main-contents">
            <div class="header">
    			<c:if test="${ empty loginUser }">
        			<a href="login">ログイン</a>
	        		<a href="signup">登録する</a>
	    		</c:if>
	    		<c:if test="${ not empty loginUser }">
	        		<a href="./">ホーム</a>
	        		<a href="setting">設定</a>
	        		<a href="logout">ログアウト</a>
	    		</c:if>
	    	</div>
	    	<div class = "calendar">
	    		<form action="./" method="get">
	    			<input type="date" name="start" value="${start}">～
	    			<input type="date" name="end" value="${end}">
	    			<button type="submit">絞込</button>
	    		</form>
	    	</div>
	    	<c:if test="${ not empty loginUser }">
	    		<div class="profile">
	        		<div class="name"><h2><c:out value="${loginUser.name}" /></h2></div>
	        		<div class="account">@<c:out value="${loginUser.account}" /></div>
	        		<div class="description"><c:out value="${loginUser.description}" /></div>
	    		</div>
			</c:if>
            <div class="copyright"> Copyright(c)TanakaRua</div>
        </div>
        <c:if test="${ not empty errorMessages }">
			<div class="errorMessages">
	        <ul>
	            <c:forEach items="${errorMessages}" var="errorMessage">
	                <li><c:out value="${errorMessage}" />
	            </c:forEach>
	        </ul>
		    </div>
		    <c:remove var="errorMessages" scope="session" />
		</c:if>
		<div class="form-area">
		    <c:if test="${ isShowMessageForm }">
		        <form action="message" method="post">
		            いま、どうしてる？<br />
		            <textarea name="text" cols="100" rows="5" class="tweet-box"></textarea>
		            <br />
		            <input type="submit" value="つぶやく">（140文字まで）
		        </form>
		    </c:if>
		</div>
		<div class="messages">
		    <c:forEach items="${messages}" var="message">
		        <div class="message">
		            <div class="account-name">
		               <span class="account">
						<a href="./?user_id=<c:out value="${message.userId}"/> ">
						<c:out value="${message.account}" />
						</a>
						</span>
		                <span class="name"><c:out value="${message.name}" /></span>
		            </div>
		            <div class="text"><pre><c:out value="${message.text}" /></pre></div>
		            <div class="date"><fmt:formatDate value="${message.createdDate}" pattern="yyyy/MM/dd HH:mm:ss" /></div>
		        </div>
				<c:if test="${ not empty loginUser and loginUser.id == message.userId}">
					<form action="deleteMessage" method="post">
						<div>
							<button type="submit">削除</button>
						</div>
						<input type="hidden" name="message_id" value="${message.id}">
					</form>
					<form action="edit" method="get">
						<div>
							<button type="submit">編集</button>
						</div>
						<input type="hidden" name="message_id" value="${message.id}">
					</form>
				</c:if>
				<div class="comments">
					<c:forEach items="${comments}" var="comment">
						<c:if test="${message.id == comment.messageId}">
							<div class="comment">
								<div class="account-name">
									<span class="account"><c:out value="${comment.account}" /></span>
									<span class="name"><c:out value="${comment.name}" /></span>
								</div>
								<div class="text"><pre><c:out value="${comment.text}" /></pre></div>
								<div class="date"><fmt:formatDate value="${comment.createdDate}" pattern="yyyy/MM/dd HH:mm:ss" /></div>
							</div>
						</c:if>
					</c:forEach>
				</div>
				<div class="form-area">
					<c:if test="${ isShowCommentForm }">
						<form action="comment" method="post">
							返信<br />
							<textarea name="comment_text" cols="100" rows="5" class="tweet-box"></textarea>
							<br />
							<input type="submit" value="返信">
							<input type="hidden" name="message_id" value="${message.id}">
						</form>
					</c:if>
				</div>
			</c:forEach>
		</div>
	</body>
</html>

