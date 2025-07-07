<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable; // Correct base class for auth
use Laravel\Sanctum\HasApiTokens;                      // Needed for Sanctum tokens
use Illuminate\Support\Carbon;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $fillable = [
        'full_name',
        'email',
        'password',
        'role_id',
        'department_id',
        'image',
        'is_active',
    ];


    protected $hidden = [
        'password',        // Hide password in JSON output
        'remember_token',  // Hide remember token as well
    ];

    protected $casts = [
        'email_verified_at' => 'datetime', // If you have this column
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // Relationships (all look correct)
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

    // Format created_at date
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
