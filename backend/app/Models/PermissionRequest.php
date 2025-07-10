<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class PermissionRequest extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'permission_type_id',
        'reason',
        'date_leave',
        'leave_morning',
        'leave_afternoon',
        'date_back',
        'back_morning',
        'back_afternoon',
        'status'
    ];

    protected $casts = [
        'leave_morning' => 'boolean',
        'leave_afternoon' => 'boolean',
        'back_morning' => 'boolean',
        'back_afternoon' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function permissionType()
    {
        return $this->belongsTo(PermissionType::class);
    }

    public function approvals()
    {
        return $this->hasMany(PermissionApproval::class);
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
}
