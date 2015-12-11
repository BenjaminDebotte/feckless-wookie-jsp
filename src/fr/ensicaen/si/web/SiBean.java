package fr.ensicaen.si.web;

import java.sql.SQLException;
import java.util.List;

import model.Client;
import dao.ClientDao;
import dao.DbClientDao;
import dao.DbOperationDao;
import dao.OperationDao;
import db.DbManagement;

public class SiBean {
	public static void init() throws SQLException {
		DbManagement.getInstance().setDelegate(new MysqlDbManagement());
		DbManagement.getInstance().connexion("jdbc:mysql://127.0.0.1/si?" +
				"user=2A&password=2A");
		ClientDao.getInstance().setDelegate(new DbClientDao());
		OperationDao.getInstance().setDelegate(new DbOperationDao());
	}
	
	public static List<Client> getClientList(String lastName, String firstName) {
		List<Client> clients;
		if(lastName.isEmpty() && firstName.isEmpty()){
			clients = ClientDao.getInstance().getClients();

		}
		else if(firstName.isEmpty()){
			clients = ClientDao.getInstance().getByName(lastName);

		}
		else{
			clients = ClientDao.getInstance().getByFullname(lastName, firstName);
		}
		
		return clients;
	}
}
