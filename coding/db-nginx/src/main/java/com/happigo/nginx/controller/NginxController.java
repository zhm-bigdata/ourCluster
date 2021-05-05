package com.happigo.nginx.controller;

import com.alibaba.fastjson.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/applog")
public class NginxController {

    private Logger logger_other = LoggerFactory.getLogger(NginxController.class);
    private Logger logger_start = LoggerFactory.getLogger(StartController .class);

    @Autowired
    private KafkaTemplate kafkaTemplate;

    @RequestMapping
    public void acceiveMessage(@RequestBody String message) {
        JSONObject jsonObject = JSONObject.parseObject(message);
        String start = jsonObject.getString("start");
        if (StringUtils.isNotEmpty(start)){
            logger_start.info(message);
            kafkaTemplate.send("start_log",message);
        }else {
            logger_other.info(message);
            kafkaTemplate.send("event_log",message);
        }
    }


}
