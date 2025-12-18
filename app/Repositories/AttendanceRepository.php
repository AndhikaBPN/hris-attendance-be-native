<?php

require_once __DIR__ . '/BaseRepository.php';

class AttendanceRepository extends BaseRepository
{
    public function findTodayAttendance(int $userId, string $date)
    {
        $sql = "
            SELECT *
            FROM attendances
            WHERE user_id = :user_id
                AND date = :date
                AND deleted = 0
            LIMIT 1
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            'user_id' => $userId,
            'date'    => $date
        ]);

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function clockIn(array $data): bool
    {
        $sql = "
            INSERT INTO attendances (
                uuid, user_id, date,
                clock_in, status,
                photo_in, geo_in,
                created_by
            ) VALUES (
                :uuid, :user_id, :date,
                :clock_in, :status,
                :photo_in, :geo_in,
                :created_by
            )
        ";

        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            'uuid'       => $data['uuid'],
            'user_id'    => $data['user_id'],
            'date'       => $data['date'],
            'clock_in'   => $data['clock_in'],
            'status'     => $data['status'],
            'photo_in'   => $data['photo_in'],
            'geo_in'     => $data['geo_in'],
            'created_by' => $data['created_by'] ?? 0
        ]);
    }

    public function clockOut(int $attendanceId, array $data): bool
    {
        $sql = "
            UPDATE attendances
            SET clock_out = :clock_out,
                photo_out = :photo_out,
                geo_out = :geo_out,
                updated_by = :updated_by
            WHERE id = :id
                AND deleted = 0
        ";

        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            'clock_out' => $data['clock_out'],
            'photo_out' => $data['photo_out'],
            'geo_out'   => $data['geo_out'],
            'updated_by'=> $data['updated_by'] ?? 0,
            'id'        => $attendanceId
        ]);
    }
}
