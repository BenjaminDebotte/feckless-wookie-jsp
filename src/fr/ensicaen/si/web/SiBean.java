package fr.ensicaen.si.web;

import java.sql.SQLException;

import dao.ClientDao;
import dao.DbClientDao;
import dao.DbOperationDao;
import dao.OperationDao;
import db.DbManagement;

public class SiBean {
	public static void init() throws SQLException {
		DbManagement.getInstance().setDelegate(new MysqlDbManagement());
		DbManagement.getInstance().connexion("jdbc:mysql://127.0.0.1/si?" +
				"user=si&password=Password1234");
		ClientDao.getInstance().setDelegate(new DbClientDao());
		OperationDao.getInstance().setDelegate(new DbOperationDao());
	}
	
	public static List<Client> getClientList(String lastName, String firstName) {
		if(lastName.isEmpty() && firstName.isEmpty()){
			clients = ClientDao.getInstance().getClients();
			out.print("<h1>Liste des clients : </h1>");

		}
		else if(firstName.isEmpty()){
			clients = ClientDao.getInstance().getByName(lastName);
			out.print("<h1>Recherche pour \"" + lastName + "\" : </h1>");

		}
		else{
			clients = ClientDao.getInstance().getByFullname(lastName, firstName);
			out.print("<h1>Recherche pour \"" + firstName + " " + lastName + "\" : </h1>\n");

		}
	}
}
