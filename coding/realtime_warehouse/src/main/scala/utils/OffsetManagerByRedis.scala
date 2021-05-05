package utils

import org.apache.kafka.common.TopicPartition
import redis.clients.jedis.Jedis

object OffsetManagerByRedis {
  // get offset from redis
  //  tyep:hash    key: offset:topic:groupId    field:partition   value: 偏移量
  def getOffsetFromRedis(topic: String, groupId: String): Map[TopicPartition, Long] = {
    val jedisCluster = MyRedisUtil.getJedisCluster()
    val hkey = String.format("offset:%s:%s", topic, groupId)
    val hValues = jedisCluster.hgetAll(hkey)
    import scala.collection.JavaConverters._ // todo
    val topicPartition = hValues
      .asScala
      .map {
        case (partition, offsetLong) => {
          (new TopicPartition(topic, partition.toInt), offsetLong.toLong)
        }
      }
      .toMap
    topicPartition
  }

  def saveOffset2Redis(topic: String, groupId: String, topicPartitionOffset: Map[TopicPartition, Long]): Unit = {
    val hKey = String.format("offset:%s:%s", topic, groupId)

  }


}
