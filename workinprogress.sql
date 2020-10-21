USE [2766_SalesMgmtRptg_Private]
GO

/****** Object:  StoredProcedure [MSIL3390].[usp_GetErrorInfo]    Script Date: 9/14/2020 2:24:52 PM ******/
DROP PROCEDURE IF EXISTS [MSIL3390].[usp_GetErrorInfo]
GO

/****** Object:  StoredProcedure [MSIL3390].[usp_GetErrorInfo]    Script Date: 9/14/2020 2:24:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MSIL3390].[usp_GetErrorInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MSIL3390].[usp_GetErrorInfo] AS' 
END
GO


  
BEGIN TRY  
    -- Generate divide-by-zero error.  
    SELECT 1/0;  
END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine.  
    EXECUTE [MSIL3390].usp_GetErrorInfo;  
END CATCH;
