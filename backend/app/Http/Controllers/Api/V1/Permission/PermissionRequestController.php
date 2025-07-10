<?php

namespace App\Http\Controllers\Api\V1\Permission;

use App\Http\Controllers\Controller;
use App\Models\PermissionRequest;
use Illuminate\Http\Request;

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
        $validated = $request->validate([
            'user_id'             => 'required|exists:users,id',
            'permission_type_id'  => 'required|exists:permission_types,id',
            'reason'              => 'nullable|string',
            'status'              => 'in:pending,approved,rejected',

            'date_leave'          => 'required|date',
            'leave_morning'       => 'boolean',
            'leave_afternoon'     => 'boolean',

            'date_back'           => 'required|date',
            'back_morning'        => 'boolean',
            'back_afternoon'      => 'boolean',
        ]);

        $validated['status'] = $validated['status'] ?? 'pending';

        $permissionRequest = PermissionRequest::create($validated);

        return response()->json([
            'message' => 'Permission request created successfully.',
            'data'    => $permissionRequest,
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

        $validated = $request->validate([
            'user_id'             => 'required|exists:users,id',
            'permission_type_id'  => 'required|exists:permission_types,id',
            'reason'              => 'nullable|string',
            'status'              => 'in:pending,approved,rejected',

            'date_leave'          => 'required|date',
            'leave_morning'       => 'boolean',
            'leave_afternoon'     => 'boolean',

            'date_back'           => 'required|date',
            'back_morning'        => 'boolean',
            'back_afternoon'      => 'boolean',
        ]);

        $permissionRequest->update($validated);

        return response()->json([
            'message' => 'Permission request updated successfully.',
            'data'    => $permissionRequest,
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
