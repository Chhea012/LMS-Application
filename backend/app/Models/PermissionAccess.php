<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;
class PermissionAccess extends Model
{
    use HasFactory;
    protected $fillable = ['role_id', 'permission_type_id'];

    public function role()
    {
        return $this->belongsTo(Role::class);
    }

    public function permissionType()
    {
        return $this->belongsTo(PermissionType::class);
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
