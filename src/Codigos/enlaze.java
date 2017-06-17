/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Codigos;

import java.sql.*;
import java.util.ArrayList;
import oracle.jdbc.OracleDatabaseMetaData;

/**
 *
 * @author Carlos
 */
public class enlaze {

    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        Connection conexion = null;
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            String BasedeDatos = "jdbc:oracle:thin:@localhost:1521:XE";
            conexion = DriverManager.getConnection(BasedeDatos, "CAMPEONATO", "CAMPEONATO");
            if (conexion != null && !conexion.isClosed()) {
                System.out.println("Conexion Exitosa!");
            } else {
                System.out.println("Conexion Fallida!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        /*Se declara el objeto que contendrá los metadatos de la BD*/
        PreparedStatement INGRESO=conexion.prepareStatement("INSERT INTO EQUIPOS(COD_EQU, NOM_EQU, DESC_EQU, CIU_EQU) VALUES(?,?,?,?)");
        INGRESO.setString(1,"z");
        INGRESO.setString(2,"MACARAa");
        INGRESO.setString(3,"ENFERMOS");
        INGRESO.setString(4,"AMBATO");
        
        int count=INGRESO.executeUpdate();
        System.out.println("Inserted countes: "+count);
        INGRESO.close();
        
        PreparedStatement stmt=conexion.prepareStatement("SELECT * FROM EQUIPOS");
        
        ResultSet rs=stmt.executeQuery();
        while (rs.next()) {
            
            System.out.println("CED:"+rs.getString("COD_EQU"));
        }
        
        

    }

}
