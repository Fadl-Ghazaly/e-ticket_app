<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Order extends Model
{
    use HasFactory;
    
    protected $guarded = ['id'];
    protected $table = 'orders';
    
    protected $fillable = [
        'transaction_time',
        'total_price',
        'total_item',
        'payment_amount',
        'payment_method',
        'cashier_id',
        'cashier_name',
    ];

    /**
     * Relasi ke OrderItem
     */
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
    
    /**
     * Optional: Casting untuk tipe data
     */
    protected $casts = [
        'transaction_time' => 'datetime',
    ];
}