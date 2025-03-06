# How to cause sql timesouts in Optimizely when adding content types under load. 

Build from standard alloy template, with the following changes/additions: 

1. Updated Optimizely to latest
1. Changed loglevel to warning
1. Added references to EPiServer.ContentDefinitionsApi and EPiServer.ContentDeliveryApi.Cms
1. Added ContentDefinitionsApi and ContentDeliveryApi to the servicecollection
1. Changed website protocol to http to avoid certificate issues

## How to run
1. Install Node.js
1. Run the project and optionally navigate to the website. (http://localhost:5000, Username: sa, password: Qwerty12345!)
1. Open console and run following command to put some load on website (via ContentDeliveryApi endpoint)
	```bash
	npx loadtest@latest -t 200 -c 1 --rps 1 -H Accept-Language:en -k http://localhost:5000/api/episerver/v3.0/content/8?expand=*
	````
1. Run the following command to add content types (via ContentDefinitions Api)
	```bash
	add_contenttypes.ps1
	````

You might need to re-run the add_contenttypes.ps1 script a few times to get the timeouts.

Please note that issue is only happening when you use lists of, or inline blocks of, other content types (which can already exist in db). Example node script generates a modest load at 1 rps whilst we previously used 50. 

## Dump
Using [dotnet dump](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/dotnet-dump) in a Linux container.

Dump: https://drive.google.com/file/d/10xRr8F7BN1FCvsnApGGuuUlYWXmojOxW/view?usp=sharing

## Exception
```
fail: EPiServer.Framework.Cache.ObjectInstanceCacheExtensions[0]
      Failed to Read cacheKey = 'EPPageData:8:en'
      Microsoft.Data.SqlClient.SqlException (0x80131904): Execution Timeout Expired.  The timeout period elapsed prior to completion of the operation or the server is not responding.
       ---> System.ComponentModel.Win32Exception (258): The wait operation timed out.
         at Microsoft.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
         at Microsoft.Data.SqlClient.SqlInternalConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
         at Microsoft.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
         at Microsoft.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
         at Microsoft.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
         at Microsoft.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString, Boolean isInternal, Boolean forDescribeParameterEncryption, Boolean shouldCacheForAlwaysEncrypted)
         at Microsoft.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean isAsync, Int32 timeout, Task& task, Boolean asyncWrite, Boolean inRetry, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
         at Microsoft.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean& usedCache, Boolean asyncWrite, Boolean inRetry, String method)
         at Microsoft.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior)
         at Microsoft.Data.SqlClient.SqlCommand.ExecuteDbDataReader(CommandBehavior behavior)
         at EPiServer.DataAccess.Internal.ContentTypeDB.<>c__DisplayClass44_0.<ListDB>b__0()
         at EPiServer.Data.Providers.Internal.SqlDatabaseExecutor.<>c__DisplayClass26_0`1.<Execute>b__0()
         at EPiServer.Data.Providers.SqlTransientErrorsRetryPolicy.Execute[TResult](Func`1 method)
         at EPiServer.DataAccess.Internal.ContentTypeDB.ListDB()
         at EPiServer.DataAccess.Internal.ContentTypeDB.InternalListCached()
         at EPiServer.DataAccess.Internal.ContentTypeDB.List()
         at EPiServer.DataAbstraction.Internal.DefaultContentTypeRepository.InternalList()
         at EPiServer.DataAbstraction.Internal.DefaultContentTypeRepository.IdLookup()
         at EPiServer.DataAbstraction.Internal.DefaultContentTypeRepository.Load(Int32 id)
         at EPiServer.DataAccess.Internal.ContentLoadDB.LoadContentInternal(ContentReference contentLink, Int32 languageBranchId, DbDataReader reader)
         at EPiServer.DataAccess.Internal.ContentLoadDB.<>c__DisplayClass2_0.<Load>b__0()
         at EPiServer.Data.Providers.Internal.SqlDatabaseExecutor.<>c__DisplayClass26_0`1.<Execute>b__0()
         at EPiServer.Data.Providers.SqlTransientErrorsRetryPolicy.Execute[TResult](Func`1 method)
         at EPiServer.DataAccess.Internal.ContentLoadDB.Load(ContentReference contentLink, Int32 languageBranchID)
         at EPiServer.Core.Internal.DefaultContentProviderDatabase.Load(ContentReference contentLink, Int32 languageBranchID)
         at EPiServer.Core.Internal.DefaultContentProvider.LoadContent(ContentReference contentLink, ILanguageSelector languageSelector)
         at EPiServer.Core.ContentProvider.<>c__DisplayClass123_0.<LoadContentFromCacheOrRepository>b__0()
         at EPiServer.Framework.Cache.ObjectInstanceCacheExtensions.ReadThroughWithWait[T](IObjectInstanceCache cache, String cacheKey, Func`1 readValue, Func`2 evictionPolicy)
      ClientConnectionId:00f4c915-167b-45c8-be80-9bf8ac6eae40
      Error Number:-2,State:0,Class:11
      Microsoft.Data.SqlClient.SqlException (0x80131904): Execution Timeout Expired.  The timeout period elapsed prior to completion of the operation or the server is not responding.
       ---> System.ComponentModel.Win32Exception (258): The wait operation timed out.
         at Microsoft.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
         at Microsoft.Data.SqlClient.SqlInternalConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
         at Microsoft.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
         at Microsoft.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
         at Microsoft.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
         at Microsoft.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString, Boolean isInternal, Boolean forDescribeParameterEncryption, Boolean shouldCacheForAlwaysEncrypted)
         at Microsoft.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean isAsync, Int32 timeout, Task& task, Boolean asyncWrite, Boolean inRetry, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
         at Microsoft.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean& usedCache, Boolean asyncWrite, Boolean inRetry, String method)
         at Microsoft.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior)
         at Microsoft.Data.SqlClient.SqlCommand.ExecuteDbDataReader(CommandBehavior behavior)
         at EPiServer.DataAccess.Internal.ContentTypeDB.<>c__DisplayClass44_0.<ListDB>b__0()
         at EPiServer.Data.Providers.Internal.SqlDatabaseExecutor.<>c__DisplayClass26_0`1.<Execute>b__0()
         at EPiServer.Data.Providers.SqlTransientErrorsRetryPolicy.Execute[TResult](Func`1 method)
         at EPiServer.DataAccess.Internal.ContentTypeDB.ListDB()
         at EPiServer.DataAccess.Internal.ContentTypeDB.InternalListCached()
         at EPiServer.DataAccess.Internal.ContentTypeDB.List()
         at EPiServer.DataAbstraction.Internal.DefaultContentTypeRepository.InternalList()
         at EPiServer.DataAbstraction.Internal.DefaultContentTypeRepository.IdLookup()
         at EPiServer.DataAbstraction.Internal.DefaultContentTypeRepository.Load(Int32 id)
         at EPiServer.DataAccess.Internal.ContentLoadDB.LoadContentInternal(ContentReference contentLink, Int32 languageBranchId, DbDataReader reader)
         at EPiServer.DataAccess.Internal.ContentLoadDB.<>c__DisplayClass2_0.<Load>b__0()
         at EPiServer.Data.Providers.Internal.SqlDatabaseExecutor.<>c__DisplayClass26_0`1.<Execute>b__0()
         at EPiServer.Data.Providers.SqlTransientErrorsRetryPolicy.Execute[TResult](Func`1 method)
         at EPiServer.DataAccess.Internal.ContentLoadDB.Load(ContentReference contentLink, Int32 languageBranchID)
         at EPiServer.Core.Internal.DefaultContentProviderDatabase.Load(ContentReference contentLink, Int32 languageBranchID)
         at EPiServer.Core.Internal.DefaultContentProvider.LoadContent(ContentReference contentLink, ILanguageSelector languageSelector)
         at EPiServer.Core.ContentProvider.<>c__DisplayClass123_0.<LoadContentFromCacheOrRepository>b__0()
         at EPiServer.Framework.Cache.ObjectInstanceCacheExtensions.ReadThroughWithWait[T](IObjectInstanceCache cache, String cacheKey, Func`1 readValue, Func`2 evictionPolicy)
      ClientConnectionId:00f4c915-167b-45c8-be80-9bf8ac6eae40
      Error Number:-2,State:0,Class:11
```
