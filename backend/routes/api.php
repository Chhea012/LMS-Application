<?php

use App\Http\Controllers\Api\V1\AccessControl\AuditLogController;
use App\Http\Controllers\Api\V1\AccessControl\PermissionAccessController;
use App\Http\Controllers\Api\V1\Department\DepartmentController;
use App\Http\Controllers\Api\V1\Notification\NotificationController;
use App\Http\Controllers\Api\V1\Permission\PermissionApprovalController;
use App\Http\Controllers\Api\V1\Permission\PermissionRequestController;
use App\Http\Controllers\Api\V1\Permission\PermissionTypeController;
use App\Http\Controllers\Api\V1\Users\RoleController;
use App\Http\Controllers\Api\V1\Users\UserController;
use App\Http\Controllers\Api\V1\Auth\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

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

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     // return $request->user();
//     return response()->json($request->user());
// });

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
});

Route::prefix('v1')->group(function () {
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
    });
});


// Route::prefix('v1')->group(function(){
//     Route::apiResource('roles', RoleController::class);
//     Route::apiResource('users', UserController::class);
//     Route::apiResource('permissiontypes', PermissionTypeController::class);
//     Route::apiResource('department', DepartmentController::class);
//     Route::apiResource('permissionrequests', PermissionRequestController::class);
//     Route::apiResource('permissionapprovals', PermissionApprovalController::class);
//     Route::apiResource('notification', NotificationController::class);
//     Route::apiResource('auditlogs', AuditLogController::class);
//     Route::apiResource('permission', PermissionAccessController::class);
// });
// Route::middleware('auth:sanctum')->put('/profile', [AuthController::class, 'update']);

Route::prefix('v1')->middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        $user = $request->user()->load(['role', 'department']);
        $user->role_name = $user->role->role_name ?? null;
        $user->department_name = $user->department->name ?? null; // 👈 Here!
        $user->image_url = $user->image ? asset('storage/' . $user->image) : null;


        return response()->json($user);
    });

    Route::put('/profile', [AuthController::class, 'update']);
    Route::put('/profile', [AuthController::class, 'update']);
    Route::apiResource('roles', RoleController::class);
    Route::apiResource('users', UserController::class);
    Route::apiResource('permissiontypes', PermissionTypeController::class);
    Route::apiResource('department', DepartmentController::class);
    Route::apiResource('permissionrequests', PermissionRequestController::class);
    Route::apiResource('permissionapprovals', PermissionApprovalController::class);
    Route::apiResource('notification', NotificationController::class);
    Route::apiResource('auditlogs', AuditLogController::class);
    Route::apiResource('permission', PermissionAccessController::class);
});