<?php

use App\Http\Controllers\Api\V1\Permission\PermissionApprovalController;
use App\Http\Controllers\Api\V1\Permission\PermissionRequestController;
use App\Http\Controllers\Api\V1\Permission\PermissionTypeController;
use App\Http\Controllers\Api\V1\Users\RoleController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use PhpParser\Node\Expr\FuncCall;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::prefix('v1')->group(function(){
    Route::apiResource('roles', RoleController::class);
    Route::apiResource('permissiontypes', PermissionTypeController::class);
    Route::apiResource('permissionrequests', PermissionRequestController::class);
    Route::apiResource('permissionapprovals', PermissionApprovalController::class);
});