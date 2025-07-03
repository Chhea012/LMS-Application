<?php

namespace App\Http\Controllers\Api\V1\AccessControl;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;

class AuditLogController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $auditlog = AuditLog::all();
        return response()->json($auditlog);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|integer|exists:users,id',
            'action' => 'required|string|max:255',
            'description' => 'nullable|string',
            'ip_address' => 'required|ip',
        ]);

        $auditlog = AuditLog::create($validated);

        return response()->json([
            'status' => 'Auditlog created successfully!',
            'auditlog' => $auditlog
        ]);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $auditlog = AuditLog::find($id);
        if (!$auditlog) {
            return response()->json(['message' => "auditlog not found !"], 404);
        }
        return response()->json($auditlog);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $auditlog = AuditLog::find($id);
        if (!$auditlog) {
            return response()->json(['message' => 'Auditlog not found!'], 404);
        }

        $validated = $request->validate([
            'user_id' => 'sometimes|integer|exists:users,id',
            'action' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'ip_address' => 'sometimes|ip',
        ]);

        $auditlog->update($validated);

        return response()->json([
            'status' => 'Auditlog updated successfully!',
            'auditlog' => $auditlog
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $auditlog = AuditLog::find($id);
        if (!$auditlog) {
            return response()->json(['message' => 'Auditlog not found !'], 404);
        }
        $auditlog->delete();
        return response()->json(['message' => 'Delete auditlog successfully !'], 200);
    }
}
