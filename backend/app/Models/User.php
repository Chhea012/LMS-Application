<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;
    protected $fillable = [
        'full_name', 'email', 'password', 'image',
        'role_id', 'department_id', 'is_active'
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
}
