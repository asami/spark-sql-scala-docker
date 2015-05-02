name := "simple"

version := "1.0"

scalaVersion := "2.10.4"

libraryDependencies += "org.apache.spark" %% "spark-core" % "1.3.1" % "provided"

libraryDependencies += "org.apache.spark" %% "spark-sql" % "1.3.1" % "provided"

assemblyOption in assembly := (assemblyOption in assembly).value.copy(includeScala = false)
