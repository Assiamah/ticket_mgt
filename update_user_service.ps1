
$path = "c:\Users\Glymin Terra Selasi\tickets_main\ticket_api\src\main\java\com\mit\ticket_mgt_api\models\users\UserService.java"
$content = Get-Content $path -Raw
$insertion = @"
    public String setForcePasswordChange(String jsonReq) throws Exception {
        if (con == null) {
            throw new Exception("Database connection is not established");
        }
        String result = null;
        String SQL = "SELECT * FROM users.set_force_password_change(?::json)";
        Connection conn = con;
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, jsonReq);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                result = rs.getString("set_force_password_change");
            }
            rs.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return result;
    }

    public String setDefaultPassword(String jsonReq) throws Exception {
        if (con == null) {
            throw new Exception("Database connection is not established");
        }
        String result = null;
        String SQL = "SELECT * FROM users.set_default_password(?::json)";
        Connection conn = con;
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, jsonReq);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                result = rs.getString("set_default_password");
            }
            rs.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return result;
    }

    public String getUserSelect() throws Exception {
"@

$newContent = $content -replace "public String getUserSelect\(\) throws Exception \{", $insertion
Set-Content -Path $path -Value $newContent
