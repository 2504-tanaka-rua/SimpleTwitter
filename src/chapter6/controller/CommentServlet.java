package chapter6.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import chapter6.beans.Comment;
import chapter6.beans.User;
import chapter6.logging.InitApplication;
import chapter6.service.CommentService;

@WebServlet(urlPatterns = { "/comment" })
public class CommentServlet extends HttpServlet {

	Logger log = Logger.getLogger("twitter");

	public CommentServlet() {
		InitApplication application = InitApplication.getInstance();
		application.init();
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		log.info(new Object() { }.getClass().getEnclosingClass().getName() +
			" : " + new Object() { }.getClass().getEnclosingMethod().getName());

		HttpSession session = request.getSession();
		List<String> errorMessages = new ArrayList<String>();

		//返信対象のつぶやきのidを取得
		String messageId = request.getParameter("message_id");
		int id = Integer.parseInt(messageId);
		//返信用のテキストボックスに入力されたテキストを取得
		String commentText = request.getParameter("comment_text");

		if (!isValid(commentText, errorMessages)) {
			session.setAttribute("errorMessages", errorMessages);
			response.sendRedirect("./");
			return;
		}

		//commentという変数にmessageId,text,userIdを代入（Beanの形式）
		Comment comment = new Comment();
		comment.setMessageId(id);
		comment.setText(commentText);

		User user = (User) session.getAttribute("loginUser");
		comment.setUserId(user.getId());

		new CommentService().insert(comment);
		response.sendRedirect("./");
	}

	private boolean isValid(String commentText, List<String> errorMessages) {

		log.info(new Object() { }.getClass().getEnclosingClass().getName() +
			" : " + new Object() { }.getClass().getEnclosingMethod().getName());

		if (StringUtils.isBlank(commentText)) {
			errorMessages.add("メッセージを入力してください");
		} else if (140 < commentText.length()) {
			errorMessages.add("140文字以下で入力してください");
		}

		if (errorMessages.size() != 0) {
			return false;
		}
		return true;
	}
}
