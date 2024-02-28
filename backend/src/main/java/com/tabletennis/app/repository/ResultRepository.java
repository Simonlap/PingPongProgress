package com.tabletennis.app.repository;

import com.tabletennis.app.models.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface ResultRepository extends JpaRepository<Result, Long> {
    Set<Result> findByUserIdAndRoundId(Long userId, Long roundId);

    Set<Result> findByUserIdAndUniqueGameIdAndRoundId(Long userId, Long uniqueGameId, Long roundId);

}
