<?php

require_once __DIR__ . '/BaseRepository.php';

class UserRepository extends BaseRepository
{
    public function findByEmail(string $email)
    {
        $sql = "
            SELECT u.*, r.name AS role_name
            FROM users u
            JOIN roles r ON r.id = u.role_id
            WHERE u.email = :email
                AND u.deleted = 0
            LIMIT 1
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->execute(['email' => $email]);

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function findById(int $id)
    {
        $sql = "
            SELECT *
            FROM users
            WHERE id = :id
                AND deleted = 0
            LIMIT 1
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->execute(['id' => $id]);

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function create(array $data): bool
    {
        $sql = "
            INSERT INTO users (
                uuid, role_id, division_id, position_id,
                employee_card_id, first_name, last_name,
                email, password, status,
                created_by
            ) VALUES (
                :uuid, :role_id, :division_id, :position_id,
                :employee_card_id, :first_name, :last_name,
                :email, :password, :status,
                :created_by
            )
        ";

        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            'uuid'             => $data['uuid'],
            'role_id'          => $data['role_id'],
            'division_id'      => $data['division_id'],
            'position_id'      => $data['position_id'],
            'employee_card_id' => $data['employee_card_id'],
            'first_name'       => $data['first_name'],
            'last_name'        => $data['last_name'],
            'email'            => $data['email'],
            'password'         => $data['password'],
            'status'           => $data['status'] ?? 'active',
            'created_by'       => $data['created_by'] ?? 0
        ]);
    }

    public function getAll(): array
    {
        $sql = "
            SELECT id, uuid, first_name, last_name, email, status
            FROM users
            WHERE deleted = 0
            ORDER BY created_at DESC
        ";

        $stmt = $this->db->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function update(int $id, array $data): bool
    {
        $sql = "
            UPDATE users
            SET
                role_id = :role_id,
                division_id = :division_id,
                position_id = :position_id,
                first_name = :first_name,
                last_name = :last_name,
                email = :email,
                phone = :phone,
                address = :address,
                status = :status,
                updated_by = :updated_by
            WHERE id = :id
                AND deleted = 0
        ";

        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            'role_id'     => $data['role_id'],
            'division_id' => $data['division_id'],
            'position_id' => $data['position_id'],
            'first_name'  => $data['first_name'],
            'last_name'   => $data['last_name'],
            'email'       => $data['email'],
            'phone'       => $data['phone'] ?? null,
            'address'     => $data['address'] ?? null,
            'status'      => $data['status'],
            'updated_by'  => $data['updated_by'] ?? 0,
            'id'          => $id
        ]);
    }

    public function softDelete(int $id, int $deletedBy = 0): bool
    {
        $sql = "
            UPDATE users
            SET
                deleted = 1,
                updated_by = :updated_by
            WHERE id = :id
            AND deleted = 0
        ";

        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            'updated_by' => $deletedBy,
            'id'         => $id
        ]);
    }

}