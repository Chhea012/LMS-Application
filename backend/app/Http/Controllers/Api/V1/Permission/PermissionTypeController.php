<?php

namespace App\Http\Controllers\Api\V1\Permission;

use App\Http\Controllers\Controller;
use App\Models\PermissionType;
use Illuminate\Http\Request;

class PermissionTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $types = PermissionType::all();
        return response()->json($types);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:permission_types,name',
            'description' => 'nullable|string',
        ]);

        $type = PermissionType::create($validated);

        return response()->json([
            'message' => 'Permission type created successfully.',
            'data' => $type
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $type = PermissionType::find($id);

        if (!$type) {
            return response()->json(['message' => 'Permission type not found.'], 404);
        }

        return response()->json($type);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $type = PermissionType::find($id);

        if (!$type) {
            return response()->json(['message' => 'Permission type not found.'], 404);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:permission_types,name,' . $id,
            'description' => 'nullable|string',
        ]);

        $type->update($validated);

        return response()->json([
            'message' => 'Permission type updated successfully.',
            'data' => $type
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $type = PermissionType::find($id);

        if (!$type) {
            return response()->json(['message' => 'Permission type not found.'], 404);
        }

        $type->delete();

        return response()->json(['message' => 'Permission type deleted successfully.']);
    }
}
