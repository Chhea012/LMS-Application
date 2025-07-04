<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class AuditLog extends Model
{
    use HasFactory;
    // app/Models/AuditLog.php

    protected $fillable = [
        'user_id',
        'action',
        'description',
        'ip_address',
    ];


    public function user()
    {
        return $this->belongsTo(User::class);
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
