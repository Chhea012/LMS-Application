<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Http\Controllers\Controller; // Don't forget to import Controller base class
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    // Register new user with role_id and department_id
    public function register(Request $request)
    {
        try {
            $fields = $request->validate([
                'full_name' => 'required|string', // Changed from 'name'
                'email' => 'required|string|email|unique:users,email',
                'password' => 'required|string|confirmed|min:6', // Added min:6
                'role_id' => 'required|exists:roles,id', // Added to match migration
            ]);

            $user = User::create([
                'full_name' => $fields['full_name'], // Changed from 'name'
                'email' => $fields['email'],
                'password' => bcrypt($fields['password']),
                'role_id' => $fields['role_id'], // Added
            ]);

            $token = $user->createToken('apptoken')->plainTextToken;

            return response()->json([
                'user' => $user,
                'token' => $token,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Registration failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    // Login user and return token
    public function login(Request $request)
    {
        try {
            $fields = $request->validate([
                'email' => 'required|string|email',
                'password' => 'required|string',
            ]);

            $user = User::where('email', $fields['email'])->first();

            if (!$user || !Hash::check($fields['password'], $user->password)) {
                return response(['message' => 'Invalid credentials'], 401);
            }

            $token = $user->createToken('apptoken')->plainTextToken;

            return response()->json([
                'user' => $user,
                'token' => $token,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Login failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    // Logout user by revoking token
    public function logout(Request $request)
    {
        try {
            $request->user()->currentAccessToken()->delete();
            return response()->json(['message' => 'Logged out']);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Logout failed: ' . $e->getMessage(),
            ], 500);
        }
    }
}