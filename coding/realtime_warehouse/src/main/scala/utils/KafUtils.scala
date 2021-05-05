package utils



import org.apache.kafka.clients.producer.ProducerConfig

import scala.collection.mutable

object KafUtils {

  def getKafkaParams() : mutable.Map[String,String] ={
    val parasMap = mutable.Map[String,String]()

    parasMap.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG,"hadoop102:9092,hadoop103:9092,hadoop104:9092");
    parasMap.put(ProducerConfig.ACKS_CONFIG,"1")
    parasMap.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer")
    parasMap.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer")
//    parasMap.put(ProducerConfig.BATCH_SIZE_CONFIG,"")
//    parasMap.put(ProducerConfig.LINGER_MS_CONFIG,"")
    return  parasMap;
  }

}
