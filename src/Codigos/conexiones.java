/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Codigos;

import java.sql.*;

/**
 *
 * @author Carlos
 */
public class conexiones {

    private Connection conection;

    public Connection getConexion() {
        return conection;
    }

    public void setConexion(Connection conexion) {
        this.conection = conexion;
    }

    public conexiones conectar() {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            String BasedeDatos = "jdbc:oracle:thin:@localhost:1521:XE";
            conection = DriverManager.getConnection(BasedeDatos, "CAMPEONATO", "CAMPEONATO");
            if (conection != null) {
                System.out.println("Conexion Exitosa!");
            } else {
                System.out.println("Conexion Fallida!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return this;
    }

    public int sig_val(String secuencia) throws SQLException {
        int sa=0;
        ResultSet rs = null;
        String sql = "SELECT " + secuencia+".NEXTVAL FROM DUAL";
        try {
            PreparedStatement stmt = conection.prepareStatement(sql);
            rs = stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
        while (rs.next()) {
            sa=rs.getInt(1);
        }
        
        return sa;
    }
    
    public void commit(){
        ResultSet rs = null;
        String sql = "COMMIT";
        try {
            PreparedStatement stmt = conection.prepareStatement(sql);
            rs = stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void escribir(String tabla, String[] codigos, String[] campos) {
        String codigos_sal = "";
        String campos_sal = "";
        String num_val = "";
        String inser = "";
        for (int i = 0; i < codigos.length; i++) {

            if (i != codigos.length - 1) {
                codigos_sal += codigos[i] + ", ";
                num_val += "?, ";
            } else {
                num_val += "?";
                codigos_sal += codigos[i];
            }
        }

        inser = "INSERT INTO " + tabla + "(" + codigos_sal + ")" + " VALUES(" + num_val + ")";
        try {
            PreparedStatement INGRESO = conection.prepareStatement(inser);
            for (int i = 0; i < campos.length; i++) {
                INGRESO.setString(i + 1, campos[i]);
            }
            INGRESO.executeUpdate();

            INGRESO.close();
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error sql");
            System.out.println("ingreso fallido");
        }

    }
    
    public void eliminar(String tabla,String campo, String valor) {
        ResultSet rs = null;
        String sql = "DELETE FROM " + tabla+" WHERE "+campo+"="+valor;
        try {
            PreparedStatement stmt = conection.prepareStatement(sql);
            rs = stmt.executeQuery();
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void actualizar(String tabla,String campo1,String campo2, String valor1,String valor2,String comparacion,String comp_valor) {
        ResultSet rs = null;
        String sql = "UPDATE " + tabla+" SET "+campo1+"= "+valor1+", "+campo2+"= "+valor2+" WHERE "+comparacion+" = "+comp_valor;
        try {
            PreparedStatement stmt = conection.prepareStatement(sql);
            rs = stmt.executeQuery();
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ResultSet consultar(String tabla) {
        ResultSet rs = null;
        String sql = "SELECT * FROM " + tabla;
        try {
            PreparedStatement stmt = conection.prepareStatement(sql);
            rs = stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        return rs;
    }
    
    public ResultSet consultar_ord(String tabla) {
        ResultSet rs = null;
        String sql = "SELECT * FROM " + tabla+" ORDER BY PUNTOS_POS DESC";
        try {
            PreparedStatement stmt = conection.prepareStatement(sql);
            rs = stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        return rs;
    }
    
    public ResultSet consultar(String tabla, String cam_consultar,String consulta) {
        ResultSet rs = null;
        String sql = "SELECT * FROM " + tabla+" WHERE "+cam_consultar+" = "+consulta;
        try {
            PreparedStatement stmt = conection.prepareStatement(sql);
            rs = stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        return rs;
    }
}
