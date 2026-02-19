
$path = "c:\Users\Glymin Terra Selasi\tickets_main\ticket_api\src\main\java\com\mit\ticket_mgt_api\controllers\UserController.java"
$content = Get-Content $path -Raw
$insertion = @"
    @PostMapping("/set_force_password_change")
    public ResponseEntity<?> setForcePasswordChange(@RequestBody String jsonReq)  throws Exception {
        userService.con = cls_db_config.getCon();
        String result = userService.setForcePasswordChange(jsonReq);
        userService.con.close();
        return ResponseEntity.ok(result);
    }

    @PostMapping("/set_default_password")
    public ResponseEntity<?> setDefaultPassword(@RequestBody String jsonReq)  throws Exception {
        userService.con = cls_db_config.getCon();
        String result = userService.setDefaultPassword(jsonReq);
        userService.con.close();
        return ResponseEntity.ok(result);
    }

      @GetMapping("/get_user_select")
"@

$newContent = [regex]::Replace($content, "\s*@GetMapping\(""/get_user_select""\)", $insertion)
Set-Content -Path $path -Value $newContent
