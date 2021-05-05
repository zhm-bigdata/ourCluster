package utils

import org.apache.commons.pool2.impl.GenericObjectPoolConfig
import redis.clients.jedis.{HostAndPort, JedisCluster, JedisPool}

object MyRedisUtil {

  private var jedisCluster: JedisCluster = null

  def getJedisCluster(): JedisCluster = {
    if (jedisCluster == null) {
      this.synchronized {
        if (jedisCluster != null) {
          return jedisCluster;
        }
        val genericObjectPoolConfig = new GenericObjectPoolConfig()
        genericObjectPoolConfig.setMaxTotal(20)
        genericObjectPoolConfig.setMaxIdle(4)
        genericObjectPoolConfig.setMinIdle(4)
        genericObjectPoolConfig.setBlockWhenExhausted(true) // 忙碌时是否等待
        genericObjectPoolConfig.setMaxWaitMillis(5000) // 忙碌时等待时长 毫秒
        genericObjectPoolConfig.setTestOnBorrow(true) // 每次获得连接的进行测试

        val hostsAndPorts = new java.util.HashSet[HostAndPort]()
        //
        hostsAndPorts.add(new HostAndPort("hadoop102", 6379))
        hostsAndPorts.add(new HostAndPort("hadoop102", 6380))
        hostsAndPorts.add(new HostAndPort("hadoop103", 6379))
        hostsAndPorts.add(new HostAndPort("hadoop103", 6380))
        hostsAndPorts.add(new HostAndPort("hadoop104", 6379))
        hostsAndPorts.add(new HostAndPort("hadoop104", 6380))
        new JedisCluster(hostsAndPorts, 5000, genericObjectPoolConfig)
      }
    } else {
      jedisCluster
    }
  }

  def main(args: Array[String]): Unit = {
    val str = jedisCluster.`type`("xx")
    println(str)
  }


}
