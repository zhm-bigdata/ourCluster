package utils

import java.io.InputStreamReader
import java.nio.charset.CharsetDecoder
import java.util.Properties

object MyPropertiesUtil {
  def load(propertiesName: String): Properties = {
    val properties = new Properties()
    properties.load(new InputStreamReader(
      Thread.currentThread().getContextClassLoader.getResourceAsStream(propertiesName),
      "utf-8"))
    properties
  }

}
