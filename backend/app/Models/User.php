<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class User extends Model
{
    use HasFactory;
    // app/Models/User.php

    protected $fillable = [
        'full_name',
        'email',
        'password',
        'role_id',
        'department_id',
        'image',
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

    // Format updated_at
    public function getUpdatedAtAttribute($value)
    {
        return Carbon::parse($value)->format('F d, Y');
    }

    public function getImageUrlAttribute()
    {
        if ($this->image) {
            return asset('storage/' . $this->image);
        }
        return null;
    }
}
