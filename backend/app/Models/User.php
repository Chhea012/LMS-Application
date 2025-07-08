<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable; // Correct base class for auth
use Laravel\Sanctum\HasApiTokens;                      // Needed for Sanctum tokens
use Illuminate\Support\Carbon;
// use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasFactory, HasApiTokens; // Added HasApiTokens

    protected $fillable = [
        'full_name',
        'email',
        'password',
        'role_id',
        'department_id',
        'image',
        'is_active',
    ];

    public function role()
    {
        return $this->belongsTo(Role::class);
    }

    public function department()
    {
        return $this->belongsTo(Department::class);
    }

    public function permissionRequests()
    {
        return $this->hasMany(PermissionRequest::class);
    }

    public function approvedPermissions()
    {
        return $this->hasMany(PermissionApproval::class, 'approved_by');
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }

    public function auditLogs()
    {
        return $this->hasMany(AuditLog::class);
    }

    // Format created_at
    public function getCreatedAtAttribute($value)
    {
        return Carbon::parse($value)->format('F d, Y');
    }

    // Format updated_at date
    public function getUpdatedAtAttribute($value)
    {
        return Carbon::parse($value)->format('F d, Y');
    }

    // Get full URL for image if exists
    public function getImageUrlAttribute()
    {
        if ($this->image) {
            return asset('storage/' . $this->image);
        }
        return null;
    }
}
