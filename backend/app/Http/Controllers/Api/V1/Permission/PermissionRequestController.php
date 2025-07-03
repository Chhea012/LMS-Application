<?php

namespace App\Http\Controllers\Api\V1\Permission;

use App\Http\Controllers\Controller;
use App\Models\PermissionRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PermissionRequestController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $requests = PermissionRequest::with(['user', 'permissionType'])->get();
        return response()->json($requests);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'permission_type_id' => 'required|exists:permission_types,id',
            'reason' => 'nullable|string',
            'status' => 'in:pending,approved,rejected',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed.',
                'errors' => $validator->errors()
            ], 422);
        }

        $permissionRequest = PermissionRequest::create($validator->validated());

        return response()->json([
            'message' => 'Permission request created successfully.',
            'data' => $permissionRequest
        ], 201);
    }


    /**
     * Display the specified resource.
     */
     public function show(string $id)
    {
        $permissionRequest = PermissionRequest::with(['user', 'permissionType'])->find($id);

        if (!$permissionRequest) {
            return response()->json(['message' => 'Permission request not found.'], 404);
        }

        return response()->json($permissionRequest);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $permissionRequest = PermissionRequest::find($id);

        if (!$permissionRequest) {
            return response()->json(['message' => 'Permission request not found.'], 404);
        }

        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'permission_type_id' => 'required|exists:permission_types,id',
            'reason' => 'nullable|string',
            'status' => 'in:pending,approved,rejected',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed.',
                'errors' => $validator->errors()
            ], 422);
        }

        $permissionRequest->update($validator->validated());

        return response()->json([
            'message' => 'Permission request updated successfully.',
            'data' => $permissionRequest
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
     public function destroy(string $id)
    {
        $permissionRequest = PermissionRequest::find($id);

        if (!$permissionRequest) {
            return response()->json(['message' => 'Permission request not found.'], 404);
        }

        $permissionRequest->delete();

        return response()->json(['message' => 'Permission request deleted successfully.']);
    }
}
