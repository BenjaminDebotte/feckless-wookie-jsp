<%@page import="fr.ensicaen.si.web.SiBean"%>
<%@page import="fr.ensicaen.si.web.MysqlDbManagement"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Operation"%>
<%@page import="dao.DbOperationDao"%>
<%@page import="dao.OperationDao"%>
<%@page import="java.util.List"%>
<%@page import="model.Client"%>
<%@page import="java.util.ArrayList"%>
<%@page import="db.DbManagement"%>
<%@page import="dao.DbClientDao"%>
<%@page import="dao.ClientDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>Consultation des données</title>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="result.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
    <script src="../../assets/js/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <!-- Begin page content -->
    <div class="container">
      <div class="page-header">
        
			 <%
			 
			 
				List<Client> clients;
			 	String firstName = request.getParameter("inputFirstname");
				String lastName = request.getParameter("inputName");
				String clientName = request.getParameter("btClient");
	
				
				if( firstName == null && lastName == null && clientName == null) //Erreur d'accès.
				{ firstName = new String(); lastName = new String(); }
				else if(clientName != null) {
					String[] parts = clientName.split(" ");
					firstName = parts[0];
					lastName = parts[1];
				}
				
				SiBean.init();
				
				
				
				if(lastName.isEmpty() && firstName.isEmpty()){
					out.print("<h1>Liste des clients : </h1>");

				}
				else if(firstName.isEmpty()){
					out.print("<h1>Recherche pour \"" + lastName + "\" : </h1>");

				}
				else{
					out.print("<h1>Recherche pour \"" + firstName + " " + lastName + "\" : </h1>\n");
				}

				clients = SiBean.getClientList(lastName, firstName);
				
				out.print("<div class=\"list-group\">\n");

				
				/* Un résultat unique implique d'afficher les opérations. */
				SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss.S");
				if(clients.size() == 1) {
					Client c = clients.get(0);

					out.print("<h2>Liste des opérations de \"" + c.getFirstName() + " " + c.getFamilyName() + "\" : </h1>\n");
					List<Operation> opes = OperationDao.getInstance().getById(c.getId());
					for(Operation op : opes) {
						out.print("<a href=\"#\" class=\"list-group-item\"> \n");
						out.print("<h4 class=\"list-group-item-heading\"> <b>Date : " + sdf.parse(op.getOperationDate().toString()).toString() + "</b>" +
																	      " | Montant : " + op.getOperationAmount() +
																	      "€</h4>\n");
						out.print("<p class=\"list-group-item-text\">" + "Opération n°"+ op.getIdOperation()  + (op.getIdCard() == null ? "" :
																		 "<br/>Carte n°"+ op.getIdCard() )+ "</p>\n");
					  	out.print("</a>\n");
					}
					
				} else {
					/* On renvoie le nom + prénom à cette page lors d'un clic sur bouton. Le résultat devrait être unique et afficher les opérations. */
					out.print("<form class=\"form-research\" action=\"process.jsp\" method=\"POST\">\n");	

					for(int i = 0; i < clients.size(); i++) {
						int j;
						final int NB_CLIENT_PER_LINE = 3; 
						out.print("<div class=\"btn-group btn-group-justified btn-group-vertical\" role=\"group\" aria-label=\"...\">\n");
						for(j = i; j < (i + NB_CLIENT_PER_LINE > clients.size() ? clients.size() : i + NB_CLIENT_PER_LINE); j++){
							Client c = clients.get(j);
							out.print("<div class=\"btn-group\" role=\"group\">\n");
							out.print("<button type=\"submit\" name=\"btClient\" class=\"list-group-item btn-block \" value=\""+ c.getFirstName() + " " + c.getFamilyName() +"\"> "+ c.getFirstName() + " " + c.getFamilyName() + "</button>\n");
							out.print("</div>\n");

						}
						i = j;
						out.print("</div>\n");

					}
					out.print("</form>\n");

				}
				out.print("</div>");

				
				out.print("<a href=\"index.html\" class=\"btn btn-primary btn-block\">Revenir à la recherche</a>\n");

				
				/* http://stackoverflow.com/questions/14723812/how-do-i-call-a-java-method-on-button-click-event-of-jsp-or-html 
					Quand on clique sur un élément, il faudrait reposter ou n'afficher que les opérations de la cible.
				*/

			%>
			     
      </div>

    </div>

    <footer class="footer">
      <div class="container">
        <p class="text-muted">Benjamin DEBOTTÉ | Guillaume PRIER.</p>
      </div>
    </footer>


    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>
