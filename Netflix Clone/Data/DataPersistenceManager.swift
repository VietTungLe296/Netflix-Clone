//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 3/9/24.
//

import CoreData
import UIKit

final class DataPersistenceManager {
    static let shared = DataPersistenceManager()

    private init() {}

    func downloadMovie(_ movie: Movie, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MovieCoreDataModel> = MovieCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

        do {
            let existingMovies = try managedContext.fetch(fetchRequest)

            if existingMovies.isEmpty {
                let saveMovie = MovieCoreDataModel(context: managedContext)
                saveMovie.id = Int64(movie.id)
                saveMovie.mediaType = movie.mediaType
                saveMovie.originalName = movie.originalName
                saveMovie.originalTitle = movie.originalTitle
                saveMovie.overview = movie.overview
                saveMovie.posterPath = movie.posterPath
                saveMovie.releaseDate = movie.releaseDate
                saveMovie.voteAverage = movie.voteAverage ?? 0
                saveMovie.voteCount = Int64(movie.voteCount ?? 0)

                try managedContext.save()
                completion(.success(()))
            } else {
                completion(.failure(CoreDataError.duplicated))
            }
        } catch {
            completion(.failure(CoreDataError.others))
        }
    }

    func fetchDownloadedMovies(_ completion: @escaping (Result<[Movie], CoreDataError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<MovieCoreDataModel>

        request = MovieCoreDataModel.fetchRequest()

        do {
            let movieList = try managedContext.fetch(request)
            completion(.success(movieList.compactMap { Movie(from: $0) }))
        } catch {
            completion(.failure(CoreDataError.others))
        }
    }

    func deleteMovie(_ movie: Movie, _ completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<MovieCoreDataModel> = MovieCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

        do {
            let movies = try managedContext.fetch(fetchRequest)

            if let movieToDelete = movies.first {
                managedContext.delete(movieToDelete)

                try managedContext.save()
                completion(.success(()))
            } else {
                completion(.failure(CoreDataError.others))
            }
        } catch {
            completion(.failure(CoreDataError.others))
        }
    }

    func deleteAllDownloadedMovies(_ completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieCoreDataModel")

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(batchDeleteRequest)
            try managedContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataError.others))
        }
    }
}
