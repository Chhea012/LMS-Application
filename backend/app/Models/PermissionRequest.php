<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PermissionRequest extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'permission_type_id', 'reason', 'status'];

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
}
