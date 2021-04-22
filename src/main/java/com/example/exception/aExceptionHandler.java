package com.example.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@ControllerAdvice
public class aExceptionHandler {
   @ExceptionHandler(value = LoginException.class)
   @ResponseBody
    public Map<String,String> loginExceptionHandler(LoginException e){
      return Map.of("success","false","message",e.getMessage());
    }
}
