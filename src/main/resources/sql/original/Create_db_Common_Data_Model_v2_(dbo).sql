IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Journal_entries]')) Drop TABLE [dbo].[Journal_entries]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Trial_balance]')) Drop TABLE [dbo].[Trial_balance]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP_activity]')) Drop TABLE [dbo].[AP_activity]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP_open_transactions]')) Drop TABLE [dbo].[AP_open_transactions]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AR_activity]')) Drop TABLE [dbo].[AR_activity]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AR_open_transactions]')) Drop TABLE [dbo].[AR_open_transactions]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP_matching]')) Drop TABLE [dbo].[AP_matching]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Purchase_invoice_line]')) Drop TABLE [dbo].[Purchase_invoice_line]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Purchase_invoice_header]')) Drop TABLE [dbo].[Purchase_invoice_header]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Goods_receipt]')) Drop TABLE [dbo].[Goods_receipt]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Purchase_order]')) Drop TABLE [dbo].[Purchase_order]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AR_matching]')) Drop TABLE [dbo].[AR_matching]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sales_invoice_line]')) Drop TABLE [dbo].[Sales_invoice_line]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Goods_despatch]')) Drop TABLE [dbo].[Goods_despatch]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sales_invoice_header]')) Drop TABLE [dbo].[Sales_invoice_header]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sales_order]')) Drop TABLE [dbo].[Sales_order]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer_master]')) Drop TABLE [dbo].[Customer_master]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vendor_master]')) Drop TABLE [dbo].[Vendor_master]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transaction_type]')) Drop TABLE [dbo].[Transaction_type]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exchange_rate]')) Drop TABLE [dbo].[Exchange_rate]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Currency_xref]')) Drop TABLE [dbo].[Currency_xref]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Currency]')) Drop TABLE [dbo].[Currency]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Chart_of_accounts]')) Drop TABLE [dbo].[Chart_of_accounts]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fiscal_calendar]')) Drop TABLE [dbo].[Fiscal_calendar]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_listing]')) Drop TABLE [dbo].[User_listing]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Source_listing]')) Drop TABLE [dbo].[Source_listing]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product_master]')) Drop TABLE [dbo].[Product_master]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Business_Unit_listing]')) Drop TABLE [dbo].[Business_Unit_listing]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Engagement]')) Drop TABLE [dbo].[Engagement]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gregorian_calendar]')) Drop TABLE [dbo].[Gregorian_calendar]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segment01_listing]')) Drop TABLE [dbo].[Segment01_listing]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segment02_listing]')) Drop TABLE [dbo].[Segment02_listing]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segment03_listing]')) Drop TABLE [dbo].[Segment03_listing]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segment04_listing]')) Drop TABLE [dbo].[Segment04_listing]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segment05_listing]')) Drop TABLE [dbo].[Segment05_listing]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Engagement](
	[engagement_id] [uniqueidentifier] NOT NULL,
	[engagement_desc] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKEngagements] PRIMARY KEY CLUSTERED 
(
	[engagement_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Segment01_listing] ******/
CREATE TABLE [dbo].[Segment01_listing](
	[segment_id] [int] IDENTITY(1,1) NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[segment_cd] [nvarchar](25) NULL,
	[segment_desc] [nvarchar](100) NULL,
	[ey_segment_group] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSegment01_listing] PRIMARY KEY CLUSTERED 
(
	[segment_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Segment02_listing] ******/
CREATE TABLE [dbo].[Segment02_listing](
	[segment_id] [int] IDENTITY(1,1) NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[segment_cd] [nvarchar](25) NULL,
	[segment_desc] [nvarchar](100) NULL,
	[ey_segment_group] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSegment02_listing] PRIMARY KEY CLUSTERED 
(
	[segment_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Segment03_listing] ******/
CREATE TABLE [dbo].[Segment03_listing](
	[segment_id] [int] IDENTITY(1,1) NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[segment_cd] [nvarchar](25) NULL,
	[segment_desc] [nvarchar](100) NULL,
	[ey_segment_group] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSegment03_listing] PRIMARY KEY CLUSTERED 
(
	[segment_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Segment04_listing] ******/
CREATE TABLE [dbo].[Segment04_listing](
	[segment_id] [int] IDENTITY(1,1) NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[segment_cd] [nvarchar](25) NULL,
	[segment_desc] [nvarchar](100) NULL,
	[ey_segment_group] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSegment04_listing] PRIMARY KEY CLUSTERED 
(
	[segment_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Segment05_listing] ******/
CREATE TABLE [dbo].[Segment05_listing](
	[segment_id] [int] IDENTITY(1,1) NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[segment_cd] [nvarchar](25) NULL,
	[segment_desc] [nvarchar](100) NULL,
	[ey_segment_group] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSegment05_listing] PRIMARY KEY CLUSTERED 
(
	[segment_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currency]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Currency](
	[curr_cd] [nvarchar](25) NOT NULL,
	[curr_desc] [nvarchar](100) NULL,
	[currency_zone] [nvarchar](100) NULL,
 CONSTRAINT [XPKCurrency] PRIMARY KEY CLUSTERED 
(
	[curr_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gregorian_calendar]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Gregorian_calendar](
	[date_id] [int] NOT NULL,
	[calendar_date] [datetime] NULL,
	[month_id] [int] NULL,
	[month_desc] [nvarchar](25) NULL,
	[quarter_id] [int] NULL,
	[quarter_desc] [nvarchar](25) NULL,
	[year_id] [int] NULL,
	[day_number_of_week] [int] NULL,
	[day_of_week_desc] [nvarchar](25) NULL,
	[day_number_of_month] [int] NULL,
	[day_number_of_year] [int] NULL,
	[week_number_of_year] [int] NULL,
 CONSTRAINT [XPKGregorian_calendar] PRIMARY KEY CLUSTERED 
(
	[date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Source_listing]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Source_listing](
	[source_id] [int] IDENTITY(1,1) NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[source_cd] [nvarchar](25) NULL,
	[source_desc] [nvarchar](100) NULL,
	[ey_source_group] [nvarchar](100) NULL,
	[erp_subledger_module] [nvarchar](100) NULL,
	[bus_process_major] [nvarchar](100) NULL,
	[bus_process_minor] [nvarchar](100) NULL,
	[sys_manual_ind] [char](1) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSource_listing] PRIMARY KEY CLUSTERED 
(
	[source_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currency_xref]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Currency_xref](
	[curr_cd] [nvarchar](25) NOT NULL,
	[client_curr_cd] [nvarchar](25) NOT NULL,
	[client_curr_desc] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKCurrency_xref] PRIMARY KEY CLUSTERED 
(
	[curr_cd] ASC,
	[client_curr_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exchange_rate]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Exchange_rate](
	[date_id] [int] NOT NULL,
	[curr_cd] [nvarchar](25) NOT NULL,
	[exchange_rate] [float] NOT NULL,
	[exchange_rate_buy] [float] NOT NULL,
	[exchange_rate_sell] [float] NOT NULL,
	[import_date_id] [int] NOT NULL,
	[import_origin] [nvarchar](100) NULL,
 CONSTRAINT [XPKExchange_rate] PRIMARY KEY CLUSTERED 
(
	[date_id] ASC,
	[curr_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Business_Unit_listing]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Business_Unit_listing](
	[bu_id] [int] IDENTITY(1,1) NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[bu_cd] [nvarchar](25) NOT NULL,
	[bu_desc] [nvarchar](100) NOT NULL,
	[bu_hier_01_cd] [nvarchar](25) NULL,
	[bu_hier_01_desc] [nvarchar](100) NULL,
	[bu_hier_02_cd] [nvarchar](25) NULL,
	[bu_hier_02_desc] [nvarchar](100) NULL,
	[bu_hier_03_cd] [nvarchar](25) NULL,
	[bu_hier_03_desc] [nvarchar](100) NULL,
	[bu_hier_04_cd] [nvarchar](25) NULL,
	[bu_hier_04_desc] [nvarchar](100) NULL,
	[bu_hier_05_cd] [nvarchar](25) NULL,
	[bu_hier_05_desc] [nvarchar](100) NULL,
	[seg_01_cd] [nvarchar](25) NULL,
	[seg_01_desc] [nvarchar](100) NULL,
	[seg_02_cd] [nvarchar](25) NULL,
	[seg_02_desc] [nvarchar](100) NULL,
	[seg_03_cd] [nvarchar](25) NULL,
	[seg_03_desc] [nvarchar](100) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKBusiness_Unit_listing] PRIMARY KEY CLUSTERED 
(
	[bu_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction_type]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Transaction_type](
	[transaction_type_id] [INT] IDENTITY(1,1) NOT NULL,
	[transaction_type_cd] [NVARCHAR](25) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[transaction_type_desc] [nvarchar](100) NULL,
	[transaction_type_group_desc] [nvarchar](100) NULL,
	[EY_transaction_type] [nvarchar](25) NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKTransaction_type] PRIMARY KEY CLUSTERED 
(
	[transaction_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_master]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Product_master](
	[product_master_id] [int] IDENTITY(1,1) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[client_product_cd] [nvarchar](25) NULL,
	[product_desc] [nvarchar](100) NULL,
	[product_group] [nvarchar](25) NULL,
	[product_type] [nvarchar](25) NULL,
	[sales_unit] [nvarchar](25) NULL,
	[purchase_unit] [nvarchar](25) NULL,
	[created_by_id] [int] NULL,
	[created_date_id] [int] NOT NULL,
	[created_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKProduct_master] PRIMARY KEY CLUSTERED 
(
	[product_master_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_listing]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[User_listing](
	[user_listing_id] [int] IDENTITY(1,1) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[client_user_id] [nvarchar](25) NOT NULL,
	[first_name] [nvarchar](100) NULL,
	[last_name] [nvarchar](100) NULL,
	[full_name] [nvarchar](100) NOT NULL,
	[department] [nvarchar](100) NULL,
	[title] [nvarchar](100) NULL,
	[role_resp] [nvarchar](100) NULL,
	[sys_manual_ind] [char](1) NULL,
	[active_ind] [char](1) NULL,
	[active_ind_change_date_id] [int] NOT NULL,
	[created_by_id] [int] NOT NULL,
	[created_date_id] [int] NOT NULL,
	[created_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKUser_listing] PRIMARY KEY CLUSTERED 
(
	[user_listing_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Chart_of_accounts]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Chart_of_accounts](
	[coa_id] [int] IDENTITY(1,1) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[coa_effective_date_id] [int] NOT NULL,
	[gl_account_cd] [nvarchar](100) NOT NULL,
	[gl_subacct_cd] [nvarchar](100) NULL,
	[gl_account_name] [nvarchar](100) NULL,
	[gl_subacct_name] [nvarchar](100) NULL,
	[consolidation_account] [nvarchar](100) NULL,
	[ey_account_type] [nvarchar](100) NULL
    CONSTRAINT chk_ey_account_type CHECK (ey_account_type IN ('Equity', 'Assets', 'Revenue', 'Expenses','Liabilities','Exclude')),
	[ey_account_sub_type] [nvarchar](100) NULL,
	[ey_account_class] [nvarchar](100) NULL,
	[ey_account_sub_class] [nvarchar](100) NULL,
	[ey_account_group_I] [nvarchar](100) NULL,
	[ey_account_group_II] [nvarchar](100) NULL,
	[ey_sub_ledger] [nvarchar](100) NULL,
	[ey_account_BS_PL] [nvarchar](100) NULL,
	[ey_cash_activity] [nvarchar](100) NULL,
	[ey_index] [nvarchar](100) NULL,
	[ey_sub_index] [nvarchar](100) NULL,
	[ey_management_account_ind] [nvarchar](100) NULL,
	[created_by_id] [int] NOT NULL,
	[created_date_id] [int] NOT NULL,
	[created_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKChart_of_accounts] PRIMARY KEY CLUSTERED 
(
	[coa_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TRIGGER [dbo].[trg_ey_account_type]
   ON [dbo].[Chart_of_accounts]
   FOR INSERT,UPDATE 
   AS 
   BEGIN 
    UPDATE [Chart_of_accounts]
    SET ey_account_type = UPPER(substring(ey_account_type,1,1))+LOWER(substring(ey_account_type,2,24))
   END
GO

/****** Object:  Table [dbo].[Fiscal_calendar]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Fiscal_calendar](
	[period_id] [int] IDENTITY(1,1) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[fiscal_period_cd] [nvarchar](50) NOT NULL,
	[fiscal_period_desc] [nvarchar](100) NULL,
	[fiscal_period_seq] [int] NULL,
	[fiscal_period_start] [nvarchar](50) NOT NULL,
	[fiscal_period_end] [nvarchar](50) NOT NULL,
	[fiscal_quarter_cd] [nvarchar](50) NULL,
	[fiscal_quarter_desc] [nvarchar](100) NULL,
	[fiscal_quarter_start] [nvarchar](50) NULL,
	[fiscal_quarter_end] [nvarchar](50) NULL,
	[fiscal_year_cd] [nvarchar](50) NULL,
	[fiscal_year_desc] [nvarchar](100) NULL,
	[fiscal_year_start] [nvarchar](50) NULL,
	[fiscal_year_end] [nvarchar](50) NULL,
	[adjustment_period] [nvarchar](1) NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKFiscal_calendar] PRIMARY KEY CLUSTERED 
(
	[period_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AP_matching]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[AP_matching](
	[receipt_note_id] [nvarchar](100) NOT NULL,
	[receipt_note_line_id] [nvarchar](100) NOT NULL,
	[purchase_invoice_cd] [nvarchar](100) NOT NULL,
	[purchase_invoice_line_cd] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[ap_matching_start_date_id] [int] NOT NULL,
	[ap_matching_end_date_id] [int] NOT NULL,
	[applied_amount] [float] NULL,
	[applied_document_amount] [float] NULL,
	[applied_quantity] [float] NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKap_matching] PRIMARY KEY CLUSTERED 
(
	[receipt_note_id] ASC,
	[receipt_note_line_id] ASC,
	[purchase_invoice_cd] ASC,
	[purchase_invoice_line_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AR_matching]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[AR_matching](
	[despatch_note_id] [nvarchar](100) NOT NULL,
	[despatch_note_line_id] [nvarchar](100) NOT NULL,
	[sales_invoice_cd] [nvarchar](100) NOT NULL,
	[sales_invoice_line_cd] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[ar_matching_start_date_id] [int] NOT NULL,
	[ar_matching_end_date_id] [int] NOT NULL,
	[applied_amount] [float] NULL,
	[applied_document_amount] [float] NULL,
	[applied_quantity] [float] NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKAR_matching] PRIMARY KEY CLUSTERED 
(
	[despatch_note_id] ASC,
	[despatch_note_line_id] ASC,
	[sales_invoice_cd] ASC,
	[sales_invoice_line_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Journal_entries]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Journal_entries](
	[je_id] [nvarchar](100) NOT NULL,
	[je_line_id] [nvarchar](100) NOT NULL,
	[coa_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[bu_id] [int] NOT NULL,
	[transaction_type_id] [int] NOT NULL,
	[source_id] [int] NOT NULL,
	[je_header_desc] [nvarchar](250) NULL,
	[je_line_desc] [nvarchar](250) NULL,
	[dr_cr_ind] [char](1) NULL,
	[amount] [float] NOT NULL,
	[amount_debit] [float] NOT NULL,
	[amount_credit] [float] NOT NULL,
	[amount_curr_cd] [nvarchar](25) NOT NULL,
	[exchange_rate] [float] NOT NULL,
	[local_amount] [float] NOT NULL,
	[local_amount_debit] [float] NOT NULL,
	[local_amount_credit] [float] NOT NULL,
	[local_amount_curr_cd] [nvarchar](25) NOT NULL,
	[local_exchange_rate] [float] NOT NULL,
	[reporting_amount] [float] NOT NULL,
	[reporting_amount_debit] [float] NOT NULL,
	[reporting_amount_credit] [float] NOT NULL,
	[reporting_amount_curr_cd] [nvarchar](25) NOT NULL,
	[reporting_exchange_rate] [float] NOT NULL,
	[period_id] [int] NOT NULL,
	[effective_date_id] [int] NOT NULL,
	[ey_je_id] [nvarchar](100) NULL,
	[ey_sys_manual_ind] [char](1) NULL,
	[activity] [nvarchar](100) NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[reversal_je_id] [nvarchar](100) NULL,
	[reversal_ind] [char](1) NULL,
	[GL_clearing_document] [nvarchar](100) NULL,
	[GL_clearing_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKJournal_entries] PRIMARY KEY CLUSTERED 
(
	[je_id] ASC,
	[je_line_id] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Purchase_invoice_line]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Purchase_invoice_line](
	[purchase_invoice_cd] [nvarchar](100) NOT NULL,
	[purchase_invoice_line_cd] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[period_id] [int] NOT NULL,
	[effective_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[purchase_inv_line_start_date_id] [int] NOT NULL,
	[purchase_inv_line_end_date_id] [int] NOT NULL,
	[line_amount] [float] NOT NULL,
	[line_amount_curr_cd] [nvarchar](25) NOT NULL,
	[line_quantity] [float] NOT NULL,
	[line_price] [float] NOT NULL,
	[line_unit_desc] [nvarchar](100) NULL,
	[line_document_amount] [float] NOT NULL,
	[line_document_amount_curr_cd] [nvarchar](25) NOT NULL,
	[line_status] [nvarchar](100) NULL,
	[tax_code] [nvarchar](25) NULL,
	[tax_code_desc] [nvarchar](100) NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKpurchase_invoice_line] PRIMARY KEY CLUSTERED 
(
	[purchase_invoice_cd] ASC,
	[purchase_invoice_line_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer_master]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Customer_master](
	[customer_master_id] [int] IDENTITY(1,1) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[customer_master_as_of_date_id] [int] NOT NULL,
	[customer_account_cd] [nvarchar](100) NULL,
	[customer_account_name] [nvarchar](100) NULL,
	[customer_group] [nvarchar](100) NULL,
	[customer_physical_street_addr1] [nvarchar](100) NULL,
	[customer_physical_street_addr2] [nvarchar](100) NULL,
	[customer_physical_city] [nvarchar](100) NULL,
	[customer_physical_state_province] [nvarchar](100) NULL,
	[customer_physical_country] [nvarchar](100) NULL,
	[customer_physical_zip_code] [nvarchar](100) NULL,
	[customer_tax_id] [nvarchar](100) NULL,
	[customer_billing_address1] [nvarchar](100) NULL,
	[customer_billing_address2] [nvarchar](100) NULL,
	[customer_billing_city] [nvarchar](100) NULL,
	[customer_billing_state_province] [nvarchar](100) NULL,
	[customer_billing_country] [nvarchar](100) NULL,
	[customer_billing_zip_code] [nvarchar](100) NULL,
	[payment_terms_desc] [nvarchar](100) NULL,
	[payment_terms_days] [int] NULL,
	[bank_name] [nvarchar](100) NULL,
	[bank_account_no] [nvarchar](100) NULL,
	[beneficiary] [nvarchar](100) NULL,
	[active_ind] [char](1) NULL,
	[active_ind_change_date_id] [int] NOT NULL,
	[credit_limit_curr_cd] [nvarchar](25) NOT NULL,
	[transaction_credit_limit] [float] NOT NULL,
	[overall_credit_limit] [float] NOT NULL,
	[ey_related_party] [nvarchar](100) NULL,
	[created_by_id] [int] NOT NULL,
	[created_date_id] [int] NOT NULL,
	[created_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKCustomer_master] PRIMARY KEY CLUSTERED 
(
	[customer_master_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trial_balance]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Trial_balance](
	[coa_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[bu_id] [int] NOT NULL,
	[period_id] [int] NOT NULL,
	[trial_balance_start_date_id] [int] NOT NULL,
	[trial_balance_end_date_id] [int] NOT NULL,
	[beginning_balance] [float] NOT NULL,
	[ending_balance] [float] NOT NULL,
	[balance_curr_cd] [nvarchar](25) NOT NULL,
	[local_beginning_balance] [float] NOT NULL,
	[local_ending_balance] [float] NOT NULL,
	[local_curr_cd] [nvarchar](25) NOT NULL,
	[reporting_beginning_balance] [float] NOT NULL,
	[reporting_ending_balance] [float] NOT NULL,
	[reporting_curr_cd] [nvarchar](25) NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKTrial_balance] PRIMARY KEY CLUSTERED 
(
	[coa_id] ASC,
	[bu_id] ASC,
	[period_id] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vendor_master]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Vendor_master](
	[vendor_master_id] [int] IDENTITY(1,1) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[vendor_master_as_of_date_id] [int] NOT NULL,
	[vendor_account_cd] [nvarchar](100) NULL,
	[vendor_account_name] [nvarchar](100) NULL,
	[vendor_group] [nvarchar](100) NULL,
	[vendor_physical_street_addr1] [nvarchar](100) NULL,
	[vendor_physical_street_addr2] [nvarchar](100) NULL,
	[vendor_physical_city] [nvarchar](100) NULL,
	[vendor_physical_state_province] [nvarchar](100) NULL,
	[vendor_physical_country] [nvarchar](100) NULL,
	[vendor_physical_zip_code] [nvarchar](100) NULL,
	[vendor_tax_id] [nvarchar](100) NULL,
	[vendor_billing_address1] [nvarchar](100) NULL,
	[vendor_billing_address2] [nvarchar](100) NULL,
	[vendor_billing_city] [nvarchar](100) NULL,
	[vendor_billing_state_province] [nvarchar](100) NULL,
	[vendor_billing_country] [nvarchar](100) NULL,
	[vendor_billing_zip_code] [nvarchar](100) NULL,
	[payment_terms_desc] [nvarchar](100) NULL,
	[payment_terms_days] [int] NULL,
	[bank_name] [nvarchar](100) NULL,
	[bank_account_no] [nvarchar](100) NULL,
	[beneficiary] [nvarchar](100) NULL,
	[active_ind] [char](1) NULL,
	[active_ind_change_date_id] [int] NOT NULL,
	[credit_limit_curr_cd] [nvarchar] (25) NOT NULL,
	[transaction_credit_limit] [float] NOT NULL,
	[overall_credit_limit] [float] NOT NULL,
	[ey_related_party] [nvarchar](100) NULL,
	[created_by_id] [int] NOT NULL,
	[created_date_id] [int] NOT NULL,
	[created_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKvendor_master] PRIMARY KEY CLUSTERED 
(
	[vendor_master_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sales_invoice_line]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Sales_invoice_line](
	[sales_invoice_cd] [nvarchar](100) NOT NULL,
	[sales_invoice_line_cd] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[period_id] [int] NOT NULL,
	[effective_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[sales_inv_line_start_date_id] [int] NOT NULL,
	[sales_inv_line_end_date_id] [int] NOT NULL,
	[line_amount] [float] NOT NULL,
	[line_amount_curr_cd] [nvarchar](25) NOT NULL,
	[line_quantity] [float] NOT NULL,
	[line_price] [float] NOT NULL,
	[line_unit_desc] [nvarchar](100) NULL,
	[line_document_amount] [float] NOT NULL,
	[line_document_amount_curr_cd] [nvarchar](25) NOT NULL,
	[line_status] [nvarchar](100) NULL,
	[tax_code] [nvarchar](25) NULL,
	[tax_code_desc] [nvarchar](100) NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSales_invoice_line] PRIMARY KEY CLUSTERED 
(
	[sales_invoice_cd] ASC,
	[sales_invoice_line_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sales_invoice_header]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Sales_invoice_header](
	[sales_invoice_cd] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[customer_master_id] [int] NOT NULL,
	[effective_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSales_invoice_header] PRIMARY KEY CLUSTERED 
(
	[sales_invoice_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Purchase_order]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Purchase_order](
	[purchase_order_cd] [nvarchar](25) NOT NULL,
	[purchase_order_line_id] [nvarchar](25) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[vendor_master_id] [int] NOT NULL,
	[period_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[purchase_order_start_date_id] [int] NOT NULL,
	[purchase_order_end_date_id] [int] NOT NULL,
	[purchase_order_date_id] [int] NOT NULL,
	[line_amount] [float] NOT NULL,
	[line_quantity] [float] NOT NULL,
	[line_price] [float] NOT NULL,
	[line_amount_curr_cd] [nvarchar](25) NOT NULL,
	[line_unit_desc] [nvarchar](100) NULL,
	[expected_receipt_date_id] [int] NOT NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKpurchase_order] PRIMARY KEY CLUSTERED 
(
	[purchase_order_cd] ASC,
	[purchase_order_line_id] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AR_open_transactions]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[AR_open_transactions](
	[transaction_cd] [nvarchar](50) NOT NULL,
	[transaction_type_id] [int] NOT NULL,
	[source_id] [int] NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[customer_master_id] [int] NOT NULL,
    [invoice_type] [nvarchar](25) NULL,
	[sales_invoice_cd] [nvarchar](100) NULL,
	[clearing_document_id] [nvarchar](100) NULL,
	[ar_open_trans_as_of_date_id] [int] NOT NULL,
	[period_id] [int] NOT NULL,
	[transaction_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[coa_id] [int] NULL,
	[dr_cr_ind] [char](1) NULL,
	[amount] [float] NOT NULL,
	[net_amount] [float] NOT NULL,
	[sales_tax] [int] NULL,
	[amount_curr_cd] [nvarchar](25) NOT NULL,
	[document_amount] [float] NOT NULL,
	[document_net_amount] [float] NOT NULL,
	[document_sales_tax] [float] NOT NULL,
	[document_amount_curr_cd] [nvarchar](25) NOT NULL,
	[reporting_amount] [float] NOT NULL,
	[reporting_sales_tax] [float] NOT NULL,
	[reporting_net_amount] [float] NOT NULL,
	[reporting_amount_curr_cd] [nvarchar](25) NOT NULL,
	[discount_terms_percentage] [float] NOT NULL,
	[discount_terms_days] [int] NULL,
	[transaction_due_date_id] [int] NOT NULL,
	[transaction_no] [nvarchar](100) NULL,
	[je_id] [nvarchar](100) NULL,
	[je_line_id] [nvarchar](100) NULL,
	[transaction_desc] [nvarchar](200) NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[closed_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKAR_open_transactions] PRIMARY KEY CLUSTERED 
(
	[transaction_cd] ASC,
	[ar_open_trans_as_of_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Goods_receipt]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Goods_receipt](
	[receipt_note_id] [nvarchar](100) NOT NULL,
	[receipt_note_line_id] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[vendor_master_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[period_id] [int] NOT NULL,
	[purchase_order_cd] [nvarchar](25) NULL,
	[purchase_order_line_id] [nvarchar](25) NULL,
	[goods_receipt_start_date_id] [int] NOT NULL,
	[goods_receipt_end_date_id] [int] NOT NULL,
	[receipt_date_id] [int] NOT NULL,
	[line_price] [float] NULL,
	[line_price_curr_cd] [nvarchar](25) NOT NULL,
	[line_quantity] [float] NOT NULL,
	[line_unit_desc] [nvarchar](100) NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[je_id] [nvarchar](100) NULL,
	[je_line_id] [nvarchar](100) NULL,
	[ship_from] [nvarchar](25) NULL,
	[ship_to] [nvarchar](25) NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKGoods_receipt] PRIMARY KEY CLUSTERED 
(
	[receipt_note_id] ASC,
	[receipt_note_line_id] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Goods_despatch]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Goods_despatch](
	[despatch_note_id] [nvarchar](100) NOT NULL,
	[despatch_note_line_id] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[customer_master_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[period_id] [int] NOT NULL,
	[sales_order_cd] [nvarchar](25) NULL,
	[sales_order_line_id] [nvarchar](25) NULL,
	[goods_despatch_start_date_id] [int] NOT NULL,
	[goods_despatch_end_date_id] [int] NOT NULL,
	[despatch_date_id] [int] NOT NULL,
	[line_price] [float] NULL,
	[line_price_curr_cd] [nvarchar](25) NOT NULL,
	[line_quantity] [float] NOT NULL,
	[line_unit_desc] [nvarchar](100) NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[je_id] [nvarchar](100) NULL,
	[je_line_id] [nvarchar](100) NULL,
	[ship_from] [nvarchar](25) NULL,
	[ship_to] [nvarchar](25) NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKGoods_despatch] PRIMARY KEY CLUSTERED 
(
	[despatch_note_id] ASC,
	[despatch_note_line_id] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sales_order]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Sales_order](
	[sales_order_cd] [nvarchar](25) NOT NULL,
	[sales_order_line_id] [nvarchar](25) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[customer_master_id] [int] NOT NULL,
	[period_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[sales_order_start_date_id] [int] NOT NULL,
	[sales_order_end_date_id] [int] NOT NULL,
	[sales_order_date_id] [int] NOT NULL,
	[line_amount] [float] NOT NULL,
	[line_quantity] [float] NOT NULL,
	[line_price] [float] NOT NULL,
	[line_amount_curr_cd] [nvarchar](25) NOT NULL,
	[line_unit_desc] [nvarchar](100) NULL,
	[expected_despatch_date_id] [int] NOT NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKSales_order] PRIMARY KEY CLUSTERED 
(
	[sales_order_cd] ASC,
	[sales_order_line_id] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Purchase_invoice_header]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[Purchase_invoice_header](
	[purchase_invoice_cd] [nvarchar](100) NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[vendor_master_id] [int] NOT NULL,
	[effective_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKPurchase_invoice_header] PRIMARY KEY CLUSTERED 
(
	[purchase_invoice_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AP_open_transactions]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[AP_open_transactions](
	[transaction_cd] [nvarchar](50) NOT NULL,
	[transaction_type_id] [int] NOT NULL,
	[source_id] [int] NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[vendor_master_id] [int] NOT NULL,
    [invoice_type] [nvarchar](25) NULL,
	[Purchase_invoice_cd] [nvarchar](100) NULL,
	[clearing_document_id] [nvarchar](100) NULL,
	[ap_open_trans_as_of_date_id] [int] NOT NULL,
	[period_id] [int] NOT NULL,
	[transaction_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[coa_id] [int] NULL,
	[dr_cr_ind] [char](1) NULL,
	[amount] [float] NOT NULL,
	[net_amount] [float] NOT NULL,
	[purchase_tax] [int] NULL,
	[amount_curr_cd] [nvarchar](25) NOT NULL,
	[document_amount] [float] NOT NULL,
	[document_net_amount] [float] NOT NULL,
	[document_purchase_tax] [float] NOT NULL,
	[document_amount_curr_cd] [nvarchar](25) NOT NULL,
	[reporting_amount] [float] NOT NULL,
	[reporting_purchase_tax] [float] NOT NULL,
	[reporting_net_amount] [float] NOT NULL,
	[reporting_amount_curr_cd] [nvarchar](25) NOT NULL,
	[discount_terms_percentage] [float] NOT NULL,
	[discount_terms_days] [int] NULL,
	[transaction_due_date_id] [int] NOT NULL,
	[transaction_no] [nvarchar](100) NULL,
	[je_id] [nvarchar](100) NULL,
	[je_line_id] [nvarchar](100) NULL,
	[transaction_desc] [nvarchar](200) NULL,
	[external_reference_number] [nvarchar](100) NULL,
	[external_reference_date_id] [int] NOT NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[closed_date_id] [int] NOT NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKap_open_transactions] PRIMARY KEY CLUSTERED 
(
	[transaction_cd] ASC,
	[ap_open_trans_as_of_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AR_activity]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[AR_activity](
	[transaction_cd] [nvarchar](50) NOT NULL,
	[transaction_type_id] [int] NOT NULL,
	[source_id] [int] NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[customer_master_id] [int] NOT NULL,
    [invoice_type] [nvarchar](25) NULL,
	[sales_invoice_cd] [nvarchar](100) NOT NULL,
	[clearing_document_id] [nvarchar](100) NULL,
	[period_id] [int] NOT NULL,
	[transaction_no] [nvarchar](100) NULL,
	[je_id] [nvarchar](100) NULL,
	[je_line_id] [nvarchar](100) NULL,
	[transaction_desc] [nvarchar](200) NULL,
	[activity_start_date_id] [int] NOT NULL,
	[activity_end_date_id] [int] NOT NULL,
	[transaction_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[coa_id] [int] NULL,
	[dr_cr_ind] [char](1) NULL,
	[amount] [float] NOT NULL,
	[sales_tax] [float] NOT NULL,
	[net_amount] [float] NOT NULL,
	[amount_curr_cd] [nvarchar](25) NOT NULL,
	[document_amount] [float] NOT NULL,
	[document_sales_tax] [float] NOT NULL,
	[document_net_amount] [float] NOT NULL,
	[document_amount_curr_cd] [nvarchar](25) NOT NULL,
	[reporting_amount] [float] NOT NULL,
	[reporting_sales_tax] [float] NOT NULL,
	[reporting_net_amount] [float] NOT NULL,
	[reporting_amount_curr_cd] [nvarchar](25) NOT NULL,
	[discount_terms_percentage] [float] NOT NULL,
	[discount_terms_days] [int] NULL,
	[transaction_due_date_id] [int] NOT NULL,
	[external_reference_number] [nvarchar](100) NULL,
	[external_reference_date_id] [int] NOT NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[closed_date_id] [int] NOT NULL,
	[posting_status] [nvarchar](100) NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKAR_activity] PRIMARY KEY CLUSTERED 
(
	[transaction_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AP_activity]    Script Date: 11/01/2012 22:27:38 ******/
CREATE TABLE [dbo].[AP_activity](
	[transaction_cd] [nvarchar](50) NOT NULL,
	[transaction_type_id] [int] NOT NULL,
	[source_id] [int] NOT NULL,
	[bu_id] [int] NOT NULL,
	[engagement_id] [uniqueidentifier] NOT NULL,
	[vendor_master_id] [int] NOT NULL,
    [invoice_type] [nvarchar](25) NULL,
	[purchase_invoice_cd] [nvarchar](100) NOT NULL,
	[clearing_document_id] [nvarchar](100) NULL,
	[period_id] [int] NOT NULL,
	[transaction_no] [nvarchar](100) NULL,
	[je_id] [nvarchar](100) NULL,
	[je_line_id] [nvarchar](100) NULL,
	[transaction_desc] [nvarchar](200) NULL,
	[activity_start_date_id] [int] NOT NULL,
	[activity_end_date_id] [int] NOT NULL,
	[transaction_date_id] [int] NOT NULL,
	[document_date_id] [int] NOT NULL,
	[coa_id] [int] NULL,
	[dr_cr_ind] [char](1) NULL,
	[amount] [float] NOT NULL,
	[purchase_tax] [float] NOT NULL,
	[net_amount] [float] NOT NULL,
	[amount_curr_cd] [nvarchar](25) NOT NULL,
	[document_amount] [float] NOT NULL,
	[document_purchase_tax] [float] NOT NULL,
	[document_net_amount] [float] NOT NULL,
	[document_amount_curr_cd] [nvarchar](25) NOT NULL,
	[reporting_amount] [float] NOT NULL,
	[reporting_purchase_tax] [float] NOT NULL,
	[reporting_net_amount] [float] NOT NULL,
	[reporting_amount_curr_cd] [nvarchar](25) NOT NULL,
	[discount_terms_percentage] [float] NOT NULL,
	[discount_terms_days] [int] NULL,
	[transaction_due_date_id] [int] NOT NULL,
	[external_reference_number] [nvarchar](100) NULL,
	[external_reference_date_id] [int] NOT NULL,
	[entry_by_id] [int] NULL,
	[entry_date_id] [int] NOT NULL,
	[entry_time_id] [int] NOT NULL,
	[last_modified_by_id] [int] NOT NULL,
	[last_modified_date_id] [int] NOT NULL,
	[approved_by_id] [int] NULL,
	[approved_by_date_id] [int] NOT NULL,
	[closed_date_id] [int] NOT NULL,
	[posting_status] [nvarchar](100) NULL,
	[segment01] [int] NOT NULL,
	[segment02] [int] NOT NULL,
	[segment03] [int] NOT NULL,
	[segment04] [int] NOT NULL,
	[segment05] [int] NOT NULL,
	[ver_start_date_id] [int] NOT NULL,
	[ver_end_date_id] [int] NULL,
	[ver_desc] [nvarchar](100) NULL,
 CONSTRAINT [XPKap_activity] PRIMARY KEY CLUSTERED 
(
	[transaction_cd] ASC,
	[ver_start_date_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  ForeignKey [R_811]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_811] FOREIGN KEY([document_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_811]
GO
/****** Object:  ForeignKey [R_812]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_812] FOREIGN KEY([document_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_812]
GO
/****** Object:  ForeignKey [R_813]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_813] FOREIGN KEY([document_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_813]
GO
/****** Object:  ForeignKey [R_814]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_814] FOREIGN KEY([document_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_814]
GO
/****** Object:  ForeignKey [R_9146]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9146] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9146]
GO
/****** Object:  ForeignKey [R_605]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_605] FOREIGN KEY([entry_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_605]
GO
/****** Object:  ForeignKey [R_606]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_606] FOREIGN KEY([entry_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_606]
GO
/****** Object:  ForeignKey [R_607]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_607] FOREIGN KEY([entry_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_607]
GO
/****** Object:  ForeignKey [R_608]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_608] FOREIGN KEY([entry_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_608]
GO
/****** Object:  ForeignKey [R_613]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[journal_entries]  WITH CHECK ADD  CONSTRAINT [R_613] FOREIGN KEY([entry_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[journal_entries] CHECK CONSTRAINT [R_613]
GO
/****** Object:  ForeignKey [R_609]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_609] FOREIGN KEY([approved_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_609]
GO
/****** Object:  ForeignKey [R_610]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_610] FOREIGN KEY([approved_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_610]
GO
/****** Object:  ForeignKey [R_611]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_611] FOREIGN KEY([approved_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_611]
GO
/****** Object:  ForeignKey [R_612]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_612] FOREIGN KEY([approved_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_612]
GO
/****** Object:  ForeignKey [R_614]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[journal_entries]  WITH CHECK ADD  CONSTRAINT [R_614] FOREIGN KEY([approved_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[journal_entries] CHECK CONSTRAINT [R_614]
GO
/****** Object:  ForeignKey [R_9147]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9147] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9147]
GO
/****** Object:  ForeignKey [R_9148]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9148] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9148]
GO
/****** Object:  ForeignKey [R_9157]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9157] FOREIGN KEY([activity_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9157]
GO
/****** Object:  ForeignKey [R_9158]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9158] FOREIGN KEY([transaction_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9158]
GO
/****** Object:  ForeignKey [R_9159]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9159] FOREIGN KEY([transaction_due_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9159]
GO
/****** Object:  ForeignKey [R_9160]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9160] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9160]
GO
/****** Object:  ForeignKey [R_9161]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9161] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9161]
GO
/****** Object:  ForeignKey [R_9162]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9162] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9162]
GO
/****** Object:  ForeignKey [R_9163]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9163] FOREIGN KEY([closed_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9163]
GO
/****** Object:  ForeignKey [R_9169]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9169] FOREIGN KEY([amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9169]
GO
/****** Object:  ForeignKey [R_9171]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9171] FOREIGN KEY([document_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9171]
GO
/****** Object:  ForeignKey [R_9191]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9191] FOREIGN KEY([external_reference_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9191]
GO
/****** Object:  ForeignKey [R_9257]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9257] FOREIGN KEY([activity_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9257]
GO
/****** Object:  ForeignKey [R_9505]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9505] FOREIGN KEY([vendor_master_id])
REFERENCES [dbo].[Vendor_master] ([vendor_master_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9505]
GO
/****** Object:  ForeignKey [R_9632]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_9632] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_9632]
GO
/****** Object:  ForeignKey [R_9139]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_matching]  WITH CHECK ADD  CONSTRAINT [R_9139] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[AP_matching] CHECK CONSTRAINT [R_9139]
GO
/****** Object:  ForeignKey [R_9140]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_matching]  WITH CHECK ADD  CONSTRAINT [R_9140] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[AP_matching] CHECK CONSTRAINT [R_9140]
GO
/****** Object:  ForeignKey [R_9141]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_matching]  WITH CHECK ADD  CONSTRAINT [R_9141] FOREIGN KEY([ap_matching_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_matching] CHECK CONSTRAINT [R_9141]
GO
/****** Object:  ForeignKey [R_9142]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_matching]  WITH CHECK ADD  CONSTRAINT [R_9142] FOREIGN KEY([ap_matching_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_matching] CHECK CONSTRAINT [R_9142]
GO
/****** Object:  ForeignKey [R_9165]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9165] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9165]
GO
/****** Object:  ForeignKey [R_9166]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9166] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9166]
GO
/****** Object:  ForeignKey [R_9168]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9168] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9168]
GO
/****** Object:  ForeignKey [R_9172]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9172] FOREIGN KEY([ap_open_trans_as_of_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9172]
GO
/****** Object:  ForeignKey [R_9173]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9173] FOREIGN KEY([transaction_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9173]
GO
/****** Object:  ForeignKey [R_9174]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9174] FOREIGN KEY([transaction_due_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9174]
GO
/****** Object:  ForeignKey [R_9175]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9175] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9175]
GO
/****** Object:  ForeignKey [R_9176]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9176] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9176]
GO
/****** Object:  ForeignKey [R_9177]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9177] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9177]
GO
/****** Object:  ForeignKey [R_9179]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9179] FOREIGN KEY([document_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9179]
GO
/****** Object:  ForeignKey [R_9180]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9180] FOREIGN KEY([amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9180]
GO
/****** Object:  ForeignKey [R_9181]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9181] FOREIGN KEY([line_price_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9180]
GO
/****** Object:  ForeignKey [R_9182]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_9182] FOREIGN KEY([line_price_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9180]
GO
/****** Object:  ForeignKey [R_9506]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9506] FOREIGN KEY([vendor_master_id])
REFERENCES [dbo].[Vendor_master] ([vendor_master_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9506]
GO
/****** Object:  ForeignKey [R_9633]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_9633] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_9633]
GO
/****** Object:  ForeignKey [R_146]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_146] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_146]
GO
/****** Object:  ForeignKey [R_147]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_147] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_147]
GO
/****** Object:  ForeignKey [R_148]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_148] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_148]
GO
/****** Object:  ForeignKey [R_157]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_157] FOREIGN KEY([activity_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_157]
GO
/****** Object:  ForeignKey [R_158]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_158] FOREIGN KEY([transaction_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_158]
GO
/****** Object:  ForeignKey [R_159]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_159] FOREIGN KEY([transaction_due_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_159]
GO
/****** Object:  ForeignKey [R_160]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_160] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_160]
GO
/****** Object:  ForeignKey [R_161]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_161] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_161]
GO
/****** Object:  ForeignKey [R_162]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_162] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_162]
GO
/****** Object:  ForeignKey [R_163]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_163] FOREIGN KEY([closed_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_163]
GO
/****** Object:  ForeignKey [R_169]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_169] FOREIGN KEY([amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_169]
GO
/****** Object:  ForeignKey [R_171]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_171] FOREIGN KEY([document_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_171]
GO
/****** Object:  ForeignKey [R_191]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_191] FOREIGN KEY([external_reference_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_191]
GO
/****** Object:  ForeignKey [R_257]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_257] FOREIGN KEY([activity_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_257]
GO
/****** Object:  ForeignKey [R_505]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_505] FOREIGN KEY([customer_master_id])
REFERENCES [dbo].[Customer_master] ([customer_master_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_505]
GO
/****** Object:  ForeignKey [R_632]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_632] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_632]
GO
/****** Object:  ForeignKey [R_139]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_matching]  WITH CHECK ADD  CONSTRAINT [R_139] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[AR_matching] CHECK CONSTRAINT [R_139]
GO
/****** Object:  ForeignKey [R_140]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_matching]  WITH CHECK ADD  CONSTRAINT [R_140] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[AR_matching] CHECK CONSTRAINT [R_140]
GO
/****** Object:  ForeignKey [R_141]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_matching]  WITH CHECK ADD  CONSTRAINT [R_141] FOREIGN KEY([ar_matching_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_matching] CHECK CONSTRAINT [R_141]
GO
/****** Object:  ForeignKey [R_142]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_matching]  WITH CHECK ADD  CONSTRAINT [R_142] FOREIGN KEY([ar_matching_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_matching] CHECK CONSTRAINT [R_142]
GO
/****** Object:  ForeignKey [R_165]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_165] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_165]
GO
/****** Object:  ForeignKey [R_166]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_166] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_166]
GO
/****** Object:  ForeignKey [R_168]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_168] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_168]
GO
/****** Object:  ForeignKey [R_172]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_172] FOREIGN KEY([ar_open_trans_as_of_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_172]
GO
/****** Object:  ForeignKey [R_173]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_173] FOREIGN KEY([transaction_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_173]
GO
/****** Object:  ForeignKey [R_174]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_174] FOREIGN KEY([transaction_due_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_174]
GO
/****** Object:  ForeignKey [R_175]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_175] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_175]
GO
/****** Object:  ForeignKey [R_176]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_176] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_176]
GO
/****** Object:  ForeignKey [R_177]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_177] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_177]
GO
/****** Object:  ForeignKey [R_179]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_179] FOREIGN KEY([document_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_179]
GO
/****** Object:  ForeignKey [R_180]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_180] FOREIGN KEY([amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_180]
GO
/****** Object:  ForeignKey [R_506]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_506] FOREIGN KEY([customer_master_id])
REFERENCES [dbo].[Customer_master] ([customer_master_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_506]
GO
/****** Object:  ForeignKey [R_633]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_633] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_633]
GO
/****** Object:  ForeignKey [R_403]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Business_Unit_listing]  WITH CHECK ADD  CONSTRAINT [R_403] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Business_Unit_listing] CHECK CONSTRAINT [R_403]
GO
/****** Object:  ForeignKey [R_404]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Chart_of_accounts]  WITH CHECK ADD  CONSTRAINT [R_404] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Chart_of_accounts] CHECK CONSTRAINT [R_404]
GO
/****** Object:  ForeignKey [R_407]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Chart_of_accounts]  WITH CHECK ADD  CONSTRAINT [R_407] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Chart_of_accounts] CHECK CONSTRAINT [R_407]
GO
/****** Object:  ForeignKey [R_411]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Chart_of_accounts]  WITH CHECK ADD  CONSTRAINT [R_411] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Chart_of_accounts] CHECK CONSTRAINT [R_411]
GO
/****** Object:  ForeignKey [R_414]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Chart_of_accounts]  WITH CHECK ADD  CONSTRAINT [R_414] FOREIGN KEY([coa_effective_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Chart_of_accounts] CHECK CONSTRAINT [R_414]
GO
/****** Object:  ForeignKey [R_15]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Currency_xref]  WITH CHECK ADD  CONSTRAINT [R_15] FOREIGN KEY([curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Currency_xref] CHECK CONSTRAINT [R_15]
GO
/****** Object:  ForeignKey [R_144]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_144] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_144]
GO
/****** Object:  ForeignKey [R_145]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_145] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_145]
GO
/****** Object:  ForeignKey [R_149]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_149] FOREIGN KEY([customer_master_as_of_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_149]
GO
/****** Object:  ForeignKey [R_150]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_150] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_150]
GO
/****** Object:  ForeignKey [R_152]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_152] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_152]
GO
/****** Object:  ForeignKey [R_153]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_153] FOREIGN KEY([created_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_153]
GO
/****** Object:  ForeignKey [R_154]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_154] FOREIGN KEY([active_ind_change_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_154]
GO
/****** Object:  ForeignKey [R_446]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Customer_master]  WITH CHECK ADD  CONSTRAINT [R_446] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[Customer_master] CHECK CONSTRAINT [R_446]
GO
/****** Object:  ForeignKey [R_19]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Exchange_rate]  WITH CHECK ADD  CONSTRAINT [R_19] FOREIGN KEY([curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Exchange_rate] CHECK CONSTRAINT [R_19]
GO
/****** Object:  ForeignKey [R_93]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Exchange_rate]  WITH CHECK ADD  CONSTRAINT [R_93] FOREIGN KEY([date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Exchange_rate] CHECK CONSTRAINT [R_93]
GO
/****** Object:  ForeignKey [R_133]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Fiscal_calendar]  WITH CHECK ADD  CONSTRAINT [R_133] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Fiscal_calendar] CHECK CONSTRAINT [R_133]
GO
/****** Object:  ForeignKey [R_408]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Fiscal_calendar]  WITH CHECK ADD  CONSTRAINT [R_408] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Fiscal_calendar] CHECK CONSTRAINT [R_408]
GO
/****** Object:  ForeignKey [R_409]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Fiscal_calendar]  WITH CHECK ADD  CONSTRAINT [R_409] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Fiscal_calendar] CHECK CONSTRAINT [R_409]
GO
/****** Object:  ForeignKey [R_224]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_224] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_224]
GO
/****** Object:  ForeignKey [R_225]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_225] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_225]
GO
/****** Object:  ForeignKey [R_226]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_226] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_226]
GO
/****** Object:  ForeignKey [R_227]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_227] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_227]
GO
/****** Object:  ForeignKey [R_230]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_230] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_230]
GO
/****** Object:  ForeignKey [R_231]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_231] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_231]
GO
/****** Object:  ForeignKey [R_232]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_232] FOREIGN KEY([despatch_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_232]
GO
/****** Object:  ForeignKey [R_233]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_233] FOREIGN KEY([goods_despatch_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_233]
GO
/****** Object:  ForeignKey [R_234]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_234] FOREIGN KEY([goods_despatch_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_234]
GO
/****** Object:  ForeignKey [R_509]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_509] FOREIGN KEY([customer_master_id])
REFERENCES [dbo].[Customer_master] ([customer_master_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_509]
GO
/****** Object:  ForeignKey [R_634]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_despatch]  WITH CHECK ADD  CONSTRAINT [R_634] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Goods_despatch] CHECK CONSTRAINT [R_634]
GO
/****** Object:  ForeignKey [R_9224]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9224] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9224]
GO
/****** Object:  ForeignKey [R_9225]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9225] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9225]
GO
/****** Object:  ForeignKey [R_9226]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9226] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9226]
GO
/****** Object:  ForeignKey [R_9227]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9227] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9227]
GO
/****** Object:  ForeignKey [R_9230]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9230] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9230]
GO
/****** Object:  ForeignKey [R_9231]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9231] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9231]
GO
/****** Object:  ForeignKey [R_9232]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9232] FOREIGN KEY([receipt_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9232]
GO
/****** Object:  ForeignKey [R_9233]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9233] FOREIGN KEY([goods_receipt_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9233]
GO
/****** Object:  ForeignKey [R_9234]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9234] FOREIGN KEY([goods_receipt_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9234]
GO
/****** Object:  ForeignKey [R_9509]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9509] FOREIGN KEY([vendor_master_id])
REFERENCES [dbo].[Vendor_master] ([vendor_master_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9509]
GO
/****** Object:  ForeignKey [R_9634]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Goods_receipt]  WITH CHECK ADD  CONSTRAINT [R_9634] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Goods_receipt] CHECK CONSTRAINT [R_9634]
GO
/****** Object:  ForeignKey [R_13]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_13] FOREIGN KEY([source_id])
REFERENCES [dbo].[Source_listing] ([source_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_13]
GO
/****** Object:  ForeignKey [R_800]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_800] FOREIGN KEY([source_id])
REFERENCES [dbo].[Source_listing] ([source_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_800]
GO
/****** Object:  ForeignKey [R_801]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_801] FOREIGN KEY([source_id])
REFERENCES [dbo].[Source_listing] ([source_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_801]
GO
/****** Object:  ForeignKey [R_802]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_802] FOREIGN KEY([source_id])
REFERENCES [dbo].[Source_listing] ([source_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_802]
GO
/****** Object:  ForeignKey [R_803]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_803] FOREIGN KEY([source_id])
REFERENCES [dbo].[Source_listing] ([source_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_803]
GO
/****** Object:  ForeignKey [R_17]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_17] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_17]
GO
/****** Object:  ForeignKey [R_4]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_4] FOREIGN KEY([effective_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_4]
GO
/****** Object:  ForeignKey [R_413]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_413] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_413]
GO
/****** Object:  ForeignKey [R_59]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_59] FOREIGN KEY([amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_59]
GO
/****** Object:  ForeignKey [R_6]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_6] FOREIGN KEY([coa_id])
REFERENCES [dbo].[Chart_of_accounts] ([coa_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_6]
GO
/****** Object:  ForeignKey [R_601]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_601] FOREIGN KEY([coa_id])
REFERENCES [dbo].[Chart_of_accounts] ([coa_id])
GO
ALTER TABLE [dbo].[AP_open_transactions] CHECK CONSTRAINT [R_601]
GO
/****** Object:  ForeignKey [R_602]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_open_transactions]  WITH CHECK ADD  CONSTRAINT [R_602] FOREIGN KEY([coa_id])
REFERENCES [dbo].[Chart_of_accounts] ([coa_id])
GO
ALTER TABLE [dbo].[AR_open_transactions] CHECK CONSTRAINT [R_602]
GO
/****** Object:  ForeignKey [R_603]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AP_activity]  WITH CHECK ADD  CONSTRAINT [R_603] FOREIGN KEY([coa_id])
REFERENCES [dbo].[Chart_of_accounts] ([coa_id])
GO
ALTER TABLE [dbo].[AP_activity] CHECK CONSTRAINT [R_603]
GO
/****** Object:  ForeignKey [R_604]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[AR_activity]  WITH CHECK ADD  CONSTRAINT [R_604] FOREIGN KEY([coa_id])
REFERENCES [dbo].[Chart_of_accounts] ([coa_id])
GO
ALTER TABLE [dbo].[AR_activity] CHECK CONSTRAINT [R_604]
GO
/****** Object:  ForeignKey [R_625]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_625] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_625]
GO
/****** Object:  ForeignKey [R_626]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_626] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_626]
GO
/****** Object:  ForeignKey [R_64]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_64] FOREIGN KEY([local_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_64]
GO
/****** Object:  ForeignKey [R_65]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_65] FOREIGN KEY([reporting_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_65]
GO
/****** Object:  ForeignKey [R_66]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_66] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_66]
GO
/****** Object:  ForeignKey [R_71]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_71] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_71]
GO
/****** Object:  ForeignKey [R_72]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Journal_entries]  WITH CHECK ADD  CONSTRAINT [R_72] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Journal_entries] CHECK CONSTRAINT [R_72]
GO
/****** Object:  ForeignKey [R_9628]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_header]  WITH CHECK ADD  CONSTRAINT [R_9628] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_header] CHECK CONSTRAINT [R_9628]
GO
/****** Object:  ForeignKey [R_9629]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_header]  WITH CHECK ADD  CONSTRAINT [R_9629] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_header] CHECK CONSTRAINT [R_9629]
GO
/****** Object:  ForeignKey [R_9630]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_header]  WITH CHECK ADD  CONSTRAINT [R_9630] FOREIGN KEY([vendor_master_id])
REFERENCES [dbo].[Vendor_master] ([vendor_master_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_header] CHECK CONSTRAINT [R_9630]
GO
/****** Object:  ForeignKey [R_9202]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9202] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9202]
GO
/****** Object:  ForeignKey [R_9203]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9203] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9203]
GO
/****** Object:  ForeignKey [R_9204]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9204] FOREIGN KEY([line_document_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9204]
GO
/****** Object:  ForeignKey [R_9205]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9205] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9205]
GO
/****** Object:  ForeignKey [R_9206]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9206] FOREIGN KEY([line_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9206]
GO
/****** Object:  ForeignKey [R_9207]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9207] FOREIGN KEY([purchase_inv_line_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9207]
GO
/****** Object:  ForeignKey [R_9208]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9208] FOREIGN KEY([purchase_inv_line_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9208]
GO
/****** Object:  ForeignKey [R_9635]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_9635] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Purchase_invoice_line] CHECK CONSTRAINT [R_9635]
GO
/****** Object:  ForeignKey [R_9135]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9135] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9135]
GO
/****** Object:  ForeignKey [R_9209]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9209] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9209]
GO
/****** Object:  ForeignKey [R_9210]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9210] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9210]
GO
/****** Object:  ForeignKey [R_9211]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9211] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9211]
GO
/****** Object:  ForeignKey [R_9213]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9213] FOREIGN KEY([purchase_order_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9213]
GO
/****** Object:  ForeignKey [R_9215]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9215] FOREIGN KEY([line_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9215]
GO
/****** Object:  ForeignKey [R_9217]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9217] FOREIGN KEY([purchase_order_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9217]
GO
/****** Object:  ForeignKey [R_9218]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9218] FOREIGN KEY([purchase_order_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9218]
GO
/****** Object:  ForeignKey [R_9219]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9219] FOREIGN KEY([expected_receipt_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9219]
GO
/****** Object:  ForeignKey [R_9220]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9220] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9220]
GO
/****** Object:  ForeignKey [R_9221]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9221] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9221]
GO
/****** Object:  ForeignKey [R_9222]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9222] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9222]
GO
/****** Object:  ForeignKey [R_9508]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9508] FOREIGN KEY([vendor_master_id])
REFERENCES [dbo].[Vendor_master] ([vendor_master_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9508]
GO
/****** Object:  ForeignKey [R_9636]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Purchase_order]  WITH CHECK ADD  CONSTRAINT [R_9636] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Purchase_order] CHECK CONSTRAINT [R_9636]
GO
/****** Object:  ForeignKey [R_628]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_header]  WITH CHECK ADD  CONSTRAINT [R_628] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Sales_invoice_header] CHECK CONSTRAINT [R_628]
GO
/****** Object:  ForeignKey [R_629]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_header]  WITH CHECK ADD  CONSTRAINT [R_629] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Sales_invoice_header] CHECK CONSTRAINT [R_629]
GO
/****** Object:  ForeignKey [R_630]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_header]  WITH CHECK ADD  CONSTRAINT [R_630] FOREIGN KEY([customer_master_id])
REFERENCES [dbo].[Customer_master] ([customer_master_id])
GO
ALTER TABLE [dbo].[Sales_invoice_header] CHECK CONSTRAINT [R_630]
GO
/****** Object:  ForeignKey [R_202]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_202] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_202]
GO
/****** Object:  ForeignKey [R_203]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_203] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_203]
GO
/****** Object:  ForeignKey [R_204]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_204] FOREIGN KEY([line_document_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_204]
GO
/****** Object:  ForeignKey [R_205]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_205] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_205]
GO
/****** Object:  ForeignKey [R_206]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_206] FOREIGN KEY([line_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_206]
GO
/****** Object:  ForeignKey [R_207]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_207] FOREIGN KEY([sales_inv_line_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_207]
GO
/****** Object:  ForeignKey [R_208]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_208] FOREIGN KEY([sales_inv_line_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_208]
GO
/****** Object:  ForeignKey [R_635]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_invoice_line]  WITH CHECK ADD  CONSTRAINT [R_635] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Sales_invoice_line] CHECK CONSTRAINT [R_635]
GO
/****** Object:  ForeignKey [R_135]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_135] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_135]
GO
/****** Object:  ForeignKey [R_209]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_209] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_209]
GO
/****** Object:  ForeignKey [R_210]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_210] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_210]
GO
/****** Object:  ForeignKey [R_211]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_211] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_211]
GO
/****** Object:  ForeignKey [R_213]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_213] FOREIGN KEY([sales_order_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_213]
GO
/****** Object:  ForeignKey [R_215]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_215] FOREIGN KEY([line_amount_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_215]
GO
/****** Object:  ForeignKey [R_217]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_217] FOREIGN KEY([sales_order_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_217]
GO
/****** Object:  ForeignKey [R_218]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_218] FOREIGN KEY([sales_order_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_218]
GO
/****** Object:  ForeignKey [R_219]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_219] FOREIGN KEY([expected_despatch_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_219]
GO
/****** Object:  ForeignKey [R_220]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_220] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_220]
GO
/****** Object:  ForeignKey [R_221]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_221] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_221]
GO
/****** Object:  ForeignKey [R_222]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_222] FOREIGN KEY([entry_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_222]
GO
/****** Object:  ForeignKey [R_508]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_508] FOREIGN KEY([customer_master_id])
REFERENCES [dbo].[Customer_master] ([customer_master_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_508]
GO
/****** Object:  ForeignKey [R_636]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Sales_order]  WITH CHECK ADD  CONSTRAINT [R_636] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Sales_order] CHECK CONSTRAINT [R_636]
GO
/****** Object:  ForeignKey [R_410]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Source_listing]  WITH CHECK ADD  CONSTRAINT [R_410] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Source_listing] CHECK CONSTRAINT [R_410]
GO
/****** Object:  ForeignKey [R_196]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Transaction_type]  WITH CHECK ADD  CONSTRAINT [R_196] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Transaction_type] CHECK CONSTRAINT [R_196]
GO
/****** Object:  ForeignKey [R_197]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Transaction_type]  WITH CHECK ADD  CONSTRAINT [R_197] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Transaction_type] CHECK CONSTRAINT [R_197]
GO
/****** Object:  ForeignKey [R_198]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Transaction_type]  WITH CHECK ADD  CONSTRAINT [R_198] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Transaction_type] CHECK CONSTRAINT [R_198]
GO
/****** Object:  ForeignKey [R_9196]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Transaction_type]  WITH CHECK ADD  CONSTRAINT [R_9196] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Transaction_type] CHECK CONSTRAINT [R_9196]
GO
/****** Object:  ForeignKey [R_9197]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Transaction_type]  WITH CHECK ADD  CONSTRAINT [R_9197] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Transaction_type] CHECK CONSTRAINT [R_9197]
GO
/****** Object:  ForeignKey [R_9198]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Transaction_type]  WITH CHECK ADD  CONSTRAINT [R_9198] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Transaction_type] CHECK CONSTRAINT [R_9198]
GO
/****** Object:  ForeignKey [R_1]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_1] FOREIGN KEY([coa_id])
REFERENCES [dbo].[Chart_of_accounts] ([coa_id])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_1]
GO
/****** Object:  ForeignKey [R_3]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_3] FOREIGN KEY([trial_balance_end_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_3]
GO
/****** Object:  ForeignKey [R_412]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_412] FOREIGN KEY([period_id])
REFERENCES [dbo].[Fiscal_calendar] ([period_id])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_412]
GO
/****** Object:  ForeignKey [R_60]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_60] FOREIGN KEY([balance_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_60]
GO
/****** Object:  ForeignKey [R_624]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_624] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_624]
GO
/****** Object:  ForeignKey [R_627]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_627] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_627]
GO
/****** Object:  ForeignKey [R_67]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_67] FOREIGN KEY([local_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_67]
GO
/****** Object:  ForeignKey [R_68]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_68] FOREIGN KEY([reporting_curr_cd])
REFERENCES [dbo].[Currency] ([curr_cd])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_68]
GO
/****** Object:  ForeignKey [R_69]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Trial_balance]  WITH CHECK ADD  CONSTRAINT [R_69] FOREIGN KEY([trial_balance_start_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Trial_balance] CHECK CONSTRAINT [R_69]
GO
/****** Object:  ForeignKey [R_405]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[User_listing]  WITH CHECK ADD  CONSTRAINT [R_405] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[User_listing] CHECK CONSTRAINT [R_405]
GO
/****** Object:  ForeignKey [R_406]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[User_listing]  WITH CHECK ADD  CONSTRAINT [R_406] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[User_listing] CHECK CONSTRAINT [R_406]
GO
/****** Object:  ForeignKey [R_499]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[User_listing]  WITH CHECK ADD  CONSTRAINT [R_499] FOREIGN KEY([active_ind_change_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[User_listing] CHECK CONSTRAINT [R_499]
GO
/****** Object:  ForeignKey [R_9144]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9144] FOREIGN KEY([bu_id])
REFERENCES [dbo].[Business_Unit_listing] ([bu_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9144]
GO
/****** Object:  ForeignKey [R_9145]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9145] FOREIGN KEY([engagement_id])
REFERENCES [dbo].[Engagement] ([engagement_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9145]
GO
/****** Object:  ForeignKey [R_9149]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9149] FOREIGN KEY([vendor_master_as_of_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9149]
GO
/****** Object:  ForeignKey [R_9150]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9150] FOREIGN KEY([approved_by_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9150]
GO
/****** Object:  ForeignKey [R_9152]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9152] FOREIGN KEY([last_modified_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9152]
GO
/****** Object:  ForeignKey [R_9153]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9153] FOREIGN KEY([created_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9153]
GO
/****** Object:  ForeignKey [R_9154]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9154] FOREIGN KEY([active_ind_change_date_id])
REFERENCES [dbo].[Gregorian_calendar] ([date_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9154]
GO
/****** Object:  ForeignKey [R_9446]    Script Date: 11/01/2012 22:27:38 ******/
ALTER TABLE [dbo].[Vendor_master]  WITH CHECK ADD  CONSTRAINT [R_9446] FOREIGN KEY([last_modified_by_id])
REFERENCES [dbo].[User_listing] ([user_listing_id])
GO
ALTER TABLE [dbo].[Vendor_master] CHECK CONSTRAINT [R_9446]
GO

------------------------------------------------------------
CREATE NONCLUSTERED INDEX [PM_N1] ON [dbo].[Product_master] 
(
	[client_product_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SC_N1] ON [dbo].[Source_listing] 
(
	[source_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BU_N1] ON [dbo].[Business_Unit_listing] 
(
	[bu_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FC_N1] ON [dbo].[Fiscal_calendar] 
(
	[fiscal_period_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [US_N1] ON [dbo].[User_listing] 
(
	[client_user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CA_N1] ON [dbo].[Chart_of_accounts] 
(
	[gl_account_cd] ASC,
	[gl_subacct_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CM_N1] ON [dbo].[Customer_master] 
(
	[customer_account_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VM_N1] ON [dbo].[Vendor_master] 
(
	[vendor_account_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TT_N1] ON [dbo].[Transaction_Type] 
(
	[transaction_type_desc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
