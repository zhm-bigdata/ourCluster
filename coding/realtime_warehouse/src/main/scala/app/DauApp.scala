package app

import org.apache.kafka.clients.consumer.ConsumerRecord
import org.apache.spark.SparkConf
import org.apache.spark.streaming.dstream.InputDStream
import org.apache.spark.streaming.kafka010.{ConsumerStrategies, KafkaUtils, LocationStrategies}
import org.apache.spark.streaming.{Seconds, StreamingContext}
import utils.{KafUtils, OffsetManagerByRedis}

object DauApp {

  def main(args: Array[String]): Unit = {

    val conf = new SparkConf()
    conf.set("spark.streaming.kafka.maxRatePerPartition", "300")
    conf.set("spark.streaming.backpressure.enabled", "true")
    conf.set("spark.streaming.stopGracefullyOnShutdown", "true")
    val ssc = new StreamingContext(conf, Seconds(5))
    val topic = "BD_ODS_DB_GMALL2020";
    var groupId: String = "dau_2021"

    //    val topics = Iterable("BD_ODS_DB_GMALL2020")
    val paraMap = KafUtils.getKafkaParams()

    val consumerStrategy = ConsumerStrategies.Subscribe(Array(topic), paraMap)
    KafkaUtils.createDirectStream(ssc, LocationStrategies.PreferConsistent, consumerStrategy)

    val offsetMap = OffsetManagerByRedis.getOffsetFromRedis(topic, groupId)

    if (offsetMap == null && offsetMap.size == 0) {
      val value = KafkaUtils.createDirectStream(ssc, LocationStrategies.PreferConsistent, consumerStrategy)
    } else {
      import scala.collection.JavaConverters._
//      val partitionToLong = offsetMap.map {
//        case (partition, l) => {
//          (partition, java.lang.Long.parseLong(l))
//        }
//      }
//      consumerStrategy.onStart(partitionToLong.asJava)
      KafkaUtils.createDirectStream(ssc,LocationStrategies.PreferConsistent,consumerStrategy)
    }


    ssc.start()
    ssc.awaitTermination()
  }
}
