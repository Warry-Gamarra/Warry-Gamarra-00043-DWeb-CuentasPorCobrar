USE [master]
GO

/*  SCRIPT PARA LA CREACI�N DE BASE DE DATOS */

CREATE DATABASE [BD_OCEF_CtasPorCobrar]
 CONTAINMENT = NONE
 ON  PRIMARY 
--( NAME = N'BD_OCEF_CtasPorCobrar', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\BD_OCEF_CtasPorCobrar.mdf' , SIZE = 10240KB , FILEGROWTH = 1024KB )
( NAME = N'BD_OCEF_CtasPorCobrar', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQL_2016E\MSSQL\DATA\BD_OCEF_CtasPorCobrar.mdf' , SIZE = 10240KB , FILEGROWTH = 1024KB )
 LOG ON 
--( NAME = N'BD_OCEF_CtasPorCobrar_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\BD_OCEF_CtasPorCobrar.ldf' , SIZE = 6144KB , FILEGROWTH = 10%)
( NAME = N'BD_OCEF_CtasPorCobrar_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQL_2016E\MSSQL\DATA\BD_OCEF_CtasPorCobrar.ldf' , SIZE = 6144KB , FILEGROWTH = 10%)
 COLLATE Modern_Spanish_CI_AS
GO

ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET COMPATIBILITY_LEVEL = 120
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET ARITHABORT OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET DISABLE_BROKER 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET READ_WRITE 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET MULTI_USER 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [BD_OCEF_CtasPorCobrar] SET DELAYED_DURABILITY = DISABLED 
GO

USE [BD_OCEF_CtasPorCobrar]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [BD_OCEF_CtasPorCobrar] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO


/*	CREACI�N DE LOGIN PARA LA BASE DE DATOS	*/

USE [master]
GO

IF NOT EXISTS (SELECT principal_id FROM sys.sql_logins WHERE name = 'UserOCEF')
BEGIN
	CREATE LOGIN [UserOCEF] WITH PASSWORD=N'123@abc', DEFAULT_DATABASE=[BD_OCEF_CtasPorCobrar], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
ELSE
BEGIN
	PRINT ('Ya existe el LOGIN UserOCEF en master.  Se omiti� la creaci�n')
END
GO


/*	CREACI�N DE USUARIO DE BASE DE DATOS	*/

USE [BD_OCEF_CtasPorCobrar]
GO

IF NOT EXISTS (SELECT uid FROM sys.sysusers WHERE name = 'UserOCEF' AND issqluser = 1)
BEGIN

	CREATE USER [UserOCEF] FOR LOGIN [UserOCEF] WITH DEFAULT_SCHEMA=[dbo]

	ALTER ROLE [db_owner] ADD MEMBER [UserOCEF]

	ALTER ROLE [db_datareader] ADD MEMBER [UserOCEF]

	ALTER ROLE [db_datawriter] ADD MEMBER [UserOCEF]

END
ELSE
BEGIN
	PRINT ('Ya existe el usuario UserOCEF en BD_OCEF_CtasPorCobrar. Se omiti� la creaci�n')
END
GO