package com.happigo.realtimeuv.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.web.bind.annotation.RestController

@RestController
object UVController {
  @Autowired
  private KafkaTemplate kafkatemplate;
  def main(args: Array[String]): Unit = {

  }

}
