﻿-- ======================================================================
-- Name: [adm].[uspResetPassword]
-- Desc: Se utiliza para restablecer contraseñas
-- Auth: Jonathan Piedra johmstone@gmail.com
-- Date: 04/21/2021
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspResetPassword]
	@Password	VARCHAR(50),
    @AdminReset BIT = NULL,
    @GUID		VARCHAR(MAX) = NULL,	
    @UserID		INT = NULL,
    @InsertUser VARCHAR(50) = NULL
AS 
    BEGIN
        SET NOCOUNT ON
        SET XACT_ABORT ON
                           
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT
            DECLARE @lLocalTran BIT = 0
                               
            IF @@TRANCOUNT = 0 
                BEGIN
                    BEGIN TRANSACTION
                    SET @lLocalTran = 1
                END

            -- =======================================================
				DECLARE	@FullName	VARCHAR(50)

                IF (@UserID IS NULL)
                    BEGIN
				        SELECT	@UserID		=	RR.[UserID],
						        @FullName	=	U.[FullName]						
				        FROM	[adm].[utbResetPasswords]  RR
						        LEFT JOIN [adm].[utbUsers] U ON U.[UserID] = RR.UserID
				        WHERE	RR.[GUID] = @GUID
				
				        UPDATE	[adm].[utbUsers]
				        SET		[PasswordHash]		=	HASHBYTES('SHA2_512',@Password),
                                [LastModifyDate]	=	GETDATE(),
						        [LastModifyUser]	=	@FullName
				        WHERE	[UserID] = @UserID

				        UPDATE 	[adm].[utbResetPasswords]
				        SET		[ActiveFlag]	=	0,
						        [LastModifyDate]	=	GETDATE(),
						        [LastModifyUser]	=	@FullName
				        WHERE	[GUID] = @GUID
                    END
                ELSE
                    BEGIN
                        UPDATE	[adm].[utbUsers]
				        SET		[PasswordHash]		=	HASHBYTES('SHA2_512',@Password),
                                [NeedResetPwd]      =   @AdminReset,
                                [LastModifyDate]	=	GETDATE(),
						        [LastModifyUser]	=	@InsertUser
				        WHERE	[UserID] = @UserID
                    END
			-- =======================================================

        IF ( @@trancount > 0
                 AND @lLocalTran = 1
               ) 
                BEGIN
                    COMMIT TRANSACTION
                END
        END TRY
        BEGIN CATCH
            IF ( @@trancount > 0
                 AND XACT_STATE() <> 0
               ) 
                BEGIN
                    ROLLBACK TRANSACTION
                END

            SELECT  @lErrorMessage = ERROR_MESSAGE() ,
                    @lErrorSeverity = ERROR_SEVERITY() ,
                    @lErrorState = ERROR_STATE()       

            RAISERROR (@lErrorMessage, @lErrorSeverity, @lErrorState);
        END CATCH
    END

    SET NOCOUNT OFF
    SET XACT_ABORT OFF