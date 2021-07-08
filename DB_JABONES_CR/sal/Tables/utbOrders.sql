﻿CREATE TABLE [sal].[utbOrders]
(
	[OrderID]			VARCHAR(50)		NOT NULL,
	[StageOrderID]		VARCHAR(50)		NOT NULL,
	[UserID]			INT				NOT NULL,			
	[OrderType]			VARCHAR(10)		NOT NULL,
	[OrderDate]			DATETIME		CONSTRAINT [utbOrdersDefaultOrderDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
	[DeliveryID]		INT				NOT NULL,
	[DeliveryAddressID]	INT				NULL,
	[FacturationInfoID]	INT				NOT NULL,
	[OrderDetails]		VARCHAR(MAX)	NOT NULL,
	[Discount]			NUMERIC(5,2)	NOT NULL,
	[TotalCart]			NUMERIC(8,2)	NOT NULL,
	[TotalDelivery]		NUMERIC(8,2)	NOT NULL,
	[StatusID]			INT				NOT NULL,
	[ProofPayment]		VARCHAR(50)		NULL,
	[ActiveFlag]		BIT				CONSTRAINT [utbOrdersDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,	
	[InsertDate]		DATETIME		CONSTRAINT [utbOrdersDefaultInsertDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]		VARCHAR (100)	CONSTRAINT [utbOrdersDefaultInsertUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]	DATETIME		CONSTRAINT [utbOrdersDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]	VARCHAR (100)	CONSTRAINT [utbOrdersDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
	CONSTRAINT [utbOrderID] PRIMARY KEY CLUSTERED ([OrderID]),
	CONSTRAINT [FK.sal.utbStagingOrders.sal.utbOrders.DeliveryID] FOREIGN KEY ([StageOrderID]) REFERENCES [sal].[utbStagingOrders] ([StageOrderID]),
	CONSTRAINT [FK.sal.utbDeliveryMethods.sal.utbOrders.DeliveryID] FOREIGN KEY ([DeliveryID]) REFERENCES [sal].[utbDeliveryMethods] ([DeliveryID]),
	CONSTRAINT [FK.sal.utbFacturationInfo.sal.utbOrders.FacturationInfoID] FOREIGN KEY ([FacturationInfoID]) REFERENCES [sal].[utbFacturationInfo] ([FacturationInfoID]),
	CONSTRAINT [FK.sal.utbOrderStatus.sal.utbOrders.StatusID] FOREIGN KEY ([StatusID]) REFERENCES [sal].[utbOrderStatus] ([StatusID]),
);