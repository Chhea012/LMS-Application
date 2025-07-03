<?php

namespace App\Http\Controllers\Api\V1\Permission;

use App\Http\Controllers\Controller;
use App\Models\PermissionApproval;
use Illuminate\Http\Request;

class PermissionApprovalController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $approvals = PermissionApproval::with(['request', 'approver'])->get();
        return response()->json($approvals, 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'permission_request_id' => 'required|exists:permission_requests,id',
            'approved_by'           => 'required|exists:users,id',
            'comments'              => 'nullable|string',
        ]);

        $approval = PermissionApproval::create($validated);

        return response()->json([
            'message' => 'Permission approval created successfully',
            'data'    => $approval->load(['request', 'approver']),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $approval = PermissionApproval::with(['request', 'approver'])->find($id);

        if (!$approval) {
            return response()->json(['message' => 'Permission approval not found'], 404);
        }

        return response()->json($approval, 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $approval = PermissionApproval::find($id);

        if (!$approval) {
            return response()->json(['message' => 'Permission approval not found'], 404);
        }

        $validated = $request->validate([
            'permission_request_id' => 'sometimes|required|exists:permission_requests,id',
            'approved_by'           => 'sometimes|required|exists:users,id',
            'comments'              => 'nullable|string',
        ]);

        $approval->update($validated);

        return response()->json([
            'message' => 'Permission approval updated successfully',
            'data'    => $approval->load(['request', 'approver']),
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $approval = PermissionApproval::find($id);

        if (!$approval) {
            return response()->json(['message' => 'Permission approval not found'], 404);
        }

        $approval->delete();

        return response()->json(['message' => 'Permission approval deleted successfully'], 200);
    }
}
