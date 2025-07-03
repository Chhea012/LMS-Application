<?php

namespace App\Http\Controllers\Api\V1\Users;

use App\Http\Controllers\Controller;
use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RoleController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $roles = Role::all();
        return response()->json([
            'status' => 'successfully!',
            'roles' => $roles
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Validate request
        $validator = Validator::make($request->all(), [
            'role_name' => 'required|in:admin,director,manager,employee',
            'level' => 'required|integer',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create role
        $role = Role::create([
            'role_name' => $request->role_name,
            'level' => $request->level,
            'description' => $request->description,
        ]);

        return response()->json([
            'status' => 'Role created successfully!',
            'role' => $role
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $role = Role::find($id);
        if (!$role) {
            return response()->json(['message' => 'Role not found!'], 404);
        }

        return response([
            'status' => 'Successfully!',
            'role' => $role
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $role = Role::find($id);
        if (!$role) {
            return response()->json(['message' => 'Role not found!'], 404);
        }

        // Validate request
        $validator = Validator::make($request->all(), [
            'role_name' => 'sometimes|required|in:admin,director,manager,employee',
            'level' => 'sometimes|required|integer',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Update role
        $role->update($request->only(['role_name', 'level', 'description']));

        return response()->json([
            'status' => 'Role updated successfully!',
            'role' => $role
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $role = Role::find($id);
        if (!$role) {
            return response()->json(['message' => 'Role not found!'], 404);
        }

        $role->delete();

        return response()->json(['message'=> 'Delete role successfully !'], 200);
    }
}
