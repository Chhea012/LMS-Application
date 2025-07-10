<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Http\Controllers\Controller; // Don't forget to import Controller base class
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

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

    public function update(Request $request)
    {
        try {
            $user = Auth::user();
            if (!$user) {
                return response()->json(['message' => 'Unauthorized'], 401);
            }

            $request->validate([
                'full_name' => 'nullable|string|max:255',
                'email' => 'nullable|email|unique:users,email,' . $user->id,
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

            // Update name and email if present, or set null explicitly
            if ($request->has('full_name')) {
                $user->full_name = $request->input('full_name');  // can be null
            }

            if ($request->has('email')) {
                $user->email = $request->input('email');  // can be null
            }

            // Handle image upload if present
            if ($request->hasFile('image')) {
                // Delete old image if exists
                if ($user->image) {
                    Storage::disk('public')->delete($user->image);
                }

                $path = $request->file('image')->store('profile_images', 'public');
                $user->image = $path;
            }

            $user->save();

            return response()->json([
                'message' => 'Profile updated successfully',
                'user' => $user,
            ]);
        } catch (\Illuminate\Validation\ValidationException $ve) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $ve->errors(),
            ], 422);
        } catch (\Exception $e) {
            \Log::error('Update profile error: ' . $e->getMessage());
            return response()->json([
                'message' => 'Update failed: ' . $e->getMessage(),
            ], 500);
        }
    }

}