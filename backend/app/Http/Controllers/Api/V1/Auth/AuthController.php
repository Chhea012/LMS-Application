<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
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