package br.gov.mg.probpms.api;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UiController {
    @GetMapping({ "/", "/app", "/app/**" })
    public String index() {
        return "forward:/index.html";
    }
}
