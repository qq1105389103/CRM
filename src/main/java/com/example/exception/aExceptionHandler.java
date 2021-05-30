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
    @ExceptionHandler(value=pageDisplayException.class)
    @ResponseBody
    public Map<String,String> pageDisplayException(pageDisplayException e){
        return Map.of("error",e.getMessage());
    }
    @ExceptionHandler(value=deleteException.class)
    @ResponseBody
    public Map<String,String> deleteExceptionHandler(deleteException e){
        return Map.of("success","false","msg",e.getMessage());
    }
    @ExceptionHandler(value = deleteRemarkException.class)
    @ResponseBody
    public Map<String,String> deleteRemarkExceptionHandler(deleteRemarkException e){
       return Map.of("msg",e.getMessage())    ;}
}
