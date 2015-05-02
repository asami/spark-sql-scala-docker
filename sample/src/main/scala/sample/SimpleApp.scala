import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.spark.sql.{SQLContext, DataFrame}

object SimpleApp extends App {
  val batting = SparkSqlUtils.createMysqlDataFrame("Simple Application", "batting")
  val count = batting.count()
  println(s"count = ${batting.count()}")
}

object SparkSqlUtils {
  def createSqlContext(name: String): SQLContext = {
    val conf = new SparkConf().setAppName(name)
    val sc = new SparkContext(conf)
    new SQLContext(sc)
  }

  def createMysqlDataFrame(name: String, table: String): DataFrame = {
    val sqlc = createSqlContext(name)
    createMysqlDataFrame(sqlc, table)
  }

  def createMysqlDataFrame(sqlc: SQLContext, table: String): DataFrame = {
    val host = System.getenv("MYSQL_SERVER_HOST")
    val port = System.getenv("MYSQL_SERVER_PORT")
    val user = System.getenv("MYSQL_SERVER_USER")
    val password = System.getenv("MYSQL_SERVER_PASSWORD")
    sqlc.load("jdbc", Map(
      "url" -> s"jdbc:mysql://$host:$port/baseball?user=$user&password=$password",
      "dbtable" -> table
    ))
  }
}
